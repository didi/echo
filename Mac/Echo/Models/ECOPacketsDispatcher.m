//
//  ECOPacketsDispatcher.m
//  Echo
//
//  Created by 陈爱彬 on 2019/5/16. Maintain by 陈爱彬
//  Description 
//

#import "ECOPacketsDispatcher.h"
#import <pthread.h>
#import <EchoSDK/ECOCoreManager.h>
#import "ECOPluginsManager.h"

#import <Cocoa/Cocoa.h>

@interface ECOPacketsDispatcher()

@end

@implementation ECOPacketsDispatcher {
    pthread_mutex_t _lock;
}
#pragma mark - LifeCycle methods
+ (instancetype)shared {
    static ECOPacketsDispatcher *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ECOPacketsDispatcher alloc] init];
    });
    return _instance;
}
- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.devices = @[].mutableCopy;
        self.authorizedDevices = @[].mutableCopy;
        self.discoverdDevices = @[].mutableCopy;
        pthread_mutex_init(&_lock, NULL);
        
        __weak typeof(self) weakSelf = self;
        [ECOCoreManager shared].deviceBlock = ^(ECOChannelDeviceInfo *device, BOOL isConnected) {
            [weakSelf device:device didUpdateToState:isConnected];
        };
        [ECOCoreManager shared].authStateChangedBlock = ^(ECOChannelDeviceInfo *device, BOOL authState) {
            [weakSelf device:device didChangedToAuthState:authState];
        };
        [ECOPluginsManager shared].receivedBlock = ^(ECOChannelDeviceInfo *device, __kindof ECOBasePlugin *plugin, id packetData) {
            [weakSelf dispatchDevice:device plugin:plugin packet:packetData];
        };
    }
    return self;
}
#pragma mark - 授权连接
- (void)device:(ECOChannelDeviceInfo *)device didChangedToAuthState:(BOOL)isAuthed {
    [self p_lock];
    [self.devices enumerateObjectsUsingBlock:^(ECODeviceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.deviceId isEqualToString:device.uuid]) {
            for (ECOProjectModel *pj in obj.projects) {
                if ([pj.deviceInfo.appInfo.appId isEqualToString:device.appInfo.appId]) {
                    pj.deviceInfo.authorizedType = device.authorizedType;
                }
            }
        }
    }];
    [self updateAuthorizedDeviceList];
    [self p_unlock];
    dispatch_async(dispatch_get_main_queue(), ^{
        !self.refreshBlock ?: self.refreshBlock(YES, YES, NO);
    });
}
- (void)updateAuthorizedDeviceList {
    self.authorizedDevices = @[].mutableCopy;
    self.discoverdDevices = @[].mutableCopy;
    [self.devices enumerateObjectsUsingBlock:^(ECODeviceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isAuthed = NO;
        for (ECOProjectModel *pj in obj.projects) {
            if (pj.deviceInfo.authorizedType == ECOAuthorizeResponseType_AllowAlways) {
                isAuthed = YES;
                break;
            }
        }
        if (isAuthed) {
            [self.authorizedDevices addObject:obj];
        }else{
            [self.discoverdDevices addObject:obj];
        }
    }];
}
#pragma mark - Public methods
//清空当前插件的数据
- (void)clearCurrentPluginPackets {
    [self p_lock];
    [self.selectedDevice.selectedProject.selectedPlugin clear];
    [self p_unlock];
}
- (void)device:(ECOChannelDeviceInfo *)device didUpdateToState:(BOOL)isConnected {
    if (!device.uuid || ![device.uuid length]) {
        return;
    }
    [self p_lock];
    __block ECODeviceModel *existDeviceModel = nil;
    [self.devices enumerateObjectsUsingBlock:^(ECODeviceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.deviceId isEqualToString:device.uuid]) {
            existDeviceModel = obj;
            *stop = YES;
        }
    }];
    if (!existDeviceModel) {
        if (isConnected) {
            //新增设备连接
            ECODeviceModel *deviceModel = [[ECODeviceModel alloc] init];
            deviceModel.deviceId = device.uuid;
            deviceModel.deviceName = device.deviceName;
            [self.devices addObject:deviceModel];
            [deviceModel updateWithDevice:device plugin:nil packet:nil];
        }
    }else{
        if (isConnected) {
            [existDeviceModel updateWithDevice:device plugin:nil packet:nil];
            //判断是否是重新连接,重新后pj.device会变更，需要重新修改赋值
            for (ECOProjectModel *pj in existDeviceModel.projects) {
                if (!pj.deviceInfo.isConnected && [pj.deviceInfo.appInfo.appId isEqualToString:device.appInfo.appId]) {
                    pj.deviceInfo = device;
                }
            }
        }else if (!isConnected && !existDeviceModel.hasPackets) {
            //未授权设备且没收到过数据，移除
            if ([existDeviceModel isEqual:self.selectedDevice]) {
                self.selectedDevice = nil;
            }
            [self.devices removeObject:existDeviceModel];
        }
    }
    [self updateAuthorizedDeviceList];
    //选中
    if (self.devices.count > 0 && !self.selectedDevice) {
        self.selectedDevice = self.devices.firstObject;
    }
    [self p_unlock];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        !self.refreshBlock ?: self.refreshBlock(YES, NO, NO);
    });
}

- (void)dispatchDevice:(ECOChannelDeviceInfo *)device
                plugin:(__kindof ECOBasePlugin *)plugin
                packet:(id)packetData {
    if (!device.uuid || ![device.uuid length]) {
        return;
    }
    [self p_lock];
    //是否刷新当前页面标记位
    BOOL refreshDevice,refreshPlugins,refreshDetail = NO;

    __block ECODeviceModel *existDeviceModel = nil;
    [self.devices enumerateObjectsUsingBlock:^(ECODeviceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.deviceId isEqualToString:device.uuid]) {
            existDeviceModel = obj;
            *stop = YES;
        }
    }];
    if (!existDeviceModel) {
        ECODeviceModel *deviceModel = [[ECODeviceModel alloc] init];
        deviceModel.deviceId = device.uuid;
        deviceModel.deviceName = device.deviceName;
        [deviceModel updateWithDevice:device plugin:plugin packet:packetData];
        [self.devices addObject:deviceModel];
        
        if (self.devices.count > 0 && !self.selectedDevice) {
            self.selectedDevice = self.devices.firstObject;
        }

        refreshDevice = YES;
        refreshPlugins = YES;
        refreshDetail = YES;
    }else{
        refreshDevice = NO;
        refreshPlugins = [existDeviceModel updateWithDevice:device plugin:plugin packet:packetData];
        
        if (self.devices.count > 0 && !self.selectedDevice) {
            self.selectedDevice = self.devices.firstObject;
        }
        
        if (packetData) {
            BOOL deviceFlag = [self.selectedDevice.deviceId isEqualToString:device.uuid];
            BOOL projectFlag = [self.selectedDevice.selectedProject.deviceInfo.appInfo.appId isEqualToString:device.appInfo.appId];
            BOOL pluginFlag = [self.selectedDevice.selectedProject.selectedPlugin.plugin isEqual:plugin];
            refreshDetail = deviceFlag && projectFlag && pluginFlag;
        }
    }
    [self updateAuthorizedDeviceList];

    [self p_unlock];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        !self.refreshBlock ?: self.refreshBlock(refreshDevice, refreshPlugins, refreshDetail);
    });
}

#pragma mark - private
- (void)p_lock {
    pthread_mutex_lock(&_lock);
}
- (void)p_unlock {
    pthread_mutex_unlock(&_lock);
}

- (ECOChannelDeviceInfo *)hostDevice {
    if (!_hostDevice) {
        _hostDevice = [ECOChannelDeviceInfo new];
    }
    return _hostDevice;
}
@end
