//
//  ECOPluginsManager.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/23. Maintain by 陈爱彬
//  Description 
//

#import "ECOPluginsManager.h"
#import <pthread.h>
#import "ECOCoreManager.h"

@interface ECOPluginsManager()

@property (nonatomic, strong) NSMapTable *pluginMap;
@end

@implementation ECOPluginsManager {
    NSRecursiveLock *_lock;
}
#pragma mark - LifeCycle
+ (instancetype)shared {
    static ECOPluginsManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ECOPluginsManager alloc] init];
    });
    return _instance;
}
- (void)dealloc {

}
- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}
#pragma mark - Public methods
- (void)registerPlugin:(__kindof ECOBasePlugin *)plugin {
    [self p_registerPlugin:plugin];
}
- (void)clearPlugins {
    [self p_lock];
    NSEnumerator *enumerator = [self.pluginMap objectEnumerator];
    __kindof ECOBasePlugin *plugin;
    while (plugin = [enumerator nextObject]) {
        plugin.sendBlock = nil;
        plugin.sendDataBlock = nil;
    }
    [self.pluginMap removeAllObjects];
    [self p_unlock];
}
//分发数据给对应的插件
- (void)dispatchDevice:(ECOChannelDeviceInfo *)device
                plugin:(__kindof ECOBasePlugin *)plugin
                packet:(id)packetData {
#if TARGET_OS_OSX
    //Mac侧逻辑
    [self p_lock];
    __kindof ECOBasePlugin *registerPlugin = [self.pluginMap objectForKey:plugin.name];
    if (registerPlugin) {
        !self.receivedBlock ?: self.receivedBlock(device, registerPlugin, packetData);
        [self p_unlock];
    }else {
        //判断是否存在已有模板或者设置了VC,如果没有不处理
        BOOL isValidPlugin = NO;
        if (plugin.templateName && [plugin.templateName length]) {
            isValidPlugin = YES;
            [self registerPlugin:plugin];
        }
        [self p_unlock];
        //重新走分发逻辑
        if (isValidPlugin) {
            [self dispatchDevice:device plugin:plugin packet:packetData];
        }
    }
#else
    //客户端侧逻辑
    [self p_lock];
    __kindof ECOBasePlugin *registerPlugin = [self.pluginMap objectForKey:plugin.name];
    if (registerPlugin) {
        [registerPlugin didReceivedPacketData:packetData fromDevice:device];
    }
    [self p_unlock];
#endif
    
}
//设备授权状态发生变更
- (void)device:(ECOChannelDeviceInfo *)device didChangedAuthState:(BOOL)isAuthed {
    [self p_lock];
    NSEnumerator *enumerator = [self.pluginMap objectEnumerator];
    __kindof ECOBasePlugin *plugin;
    while (plugin = [enumerator nextObject]) {
        [plugin device:device didChangedAuthState:isAuthed];
    }
    [self p_unlock];
}
#pragma mark - 注册插件
- (void)p_registerPlugin:(__kindof ECOBasePlugin *)plugin {
    if (!plugin || ![plugin isKindOfClass:[ECOBasePlugin class]]) {
        NSAssert(![plugin isKindOfClass:[ECOBasePlugin class]], @">>[ECOPluginManager] register plugin failed!!!");
        return;
    }
    if (!plugin.name) {
        NSAssert(!plugin.name, @">>[ECOPluginManager] pluginName invalid!!!");
        return;
    }
    [self p_lock];
    [self.pluginMap setObject:plugin forKey:plugin.name];
    __weak typeof(self) weakSelf = self;
    __weak typeof(plugin) weakPlugin = plugin;
    plugin.sendBlock = ^(id data) {
        [weakSelf plugin:weakPlugin willSendData:data type:ECOPacketDataType_JSON toDevice:nil];
    };
    plugin.sendDataBlock = ^(NSData *data) {
        [weakSelf plugin:weakPlugin willSendData:data type:ECOPacketDataType_Data toDevice:nil];
    };
    plugin.deviceSendBlock = ^(ECOChannelDeviceInfo *device, id data) {
        [weakSelf plugin:weakPlugin willSendData:data type:ECOPacketDataType_JSON toDevice:device];
    };
    plugin.deviceSendDataBlock = ^(ECOChannelDeviceInfo *device, NSData *data) {
        [weakSelf plugin:weakPlugin willSendData:data type:ECOPacketDataType_Data toDevice:device];
    };
    
    [self p_unlock];
}
#pragma mark - 数据接收+发送
//发送数据
- (void)plugin:(__kindof ECOBasePlugin *)plugin willSendData:(id)data type:(ECOPacketDataType)type toDevice:(ECOChannelDeviceInfo *)device {
//    NSLog(@"<<[ECOPluginsManager] %@ plugin sendData:%@", plugin.pluginName, data);
    //封装数据
    if (!data) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[ECOCoreManager shared] sendPacketData:data type:type plugin:plugin toDevice:device];
    });
}
#pragma mark - private
- (void)p_lock {
    [_lock lock];
}
- (void)p_unlock {
    [_lock unlock];
}
#pragma mark - getters
- (NSMapTable *)pluginMap {
    if (!_pluginMap) {
        _pluginMap = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _pluginMap;
}
@end
