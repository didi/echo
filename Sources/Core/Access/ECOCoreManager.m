//
//  ECOCoreManager.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/24. Maintain by 陈爱彬
//  Description 
//

#import "ECOCoreManager.h"
#import "ECOPluginsManager.h"

@interface ECOCoreManager()

@property (nonatomic, strong) ECOPacketClient *packetClient;
@end

@implementation ECOCoreManager

#pragma mark - LifeCycle methods
+ (instancetype)shared {
    static ECOCoreManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ECOCoreManager alloc] init];
    });
    return _instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)start {
    [self stop];
    if (!_packetClient) {
        _packetClient = [[ECOPacketClient alloc] init];
        __weak typeof(self) weakSelf = self;
        _packetClient.receivedBlock = ^(ECOChannelDeviceInfo *device, NSData *data, NSDictionary *extraInfo) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf device:device receivedPacketData:data extraInfo:extraInfo];
        };
#if TARGET_OS_OSX
        _packetClient.deviceBlock = ^(ECOChannelDeviceInfo *device, BOOL isConnected) {
            !weakSelf.deviceBlock ?: weakSelf.deviceBlock(device, isConnected);
        };
#endif
#if TARGET_OS_IPHONE
        _packetClient.requestAuthBlock = ^(ECOChannelDeviceInfo *device, BOOL authState) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !weakSelf.requestAuthBlock ?: weakSelf.requestAuthBlock(device, authState);
            });
        };
#endif
        _packetClient.authStateChangedBlock = ^(ECOChannelDeviceInfo *device, BOOL authState) {
            !weakSelf.authStateChangedBlock ?: weakSelf.authStateChangedBlock(device, authState);
            [weakSelf device:device didChangedAuthStatus:authState];
        };
    }
}
- (void)stop {
    self.packetClient.receivedBlock = nil;
    self.packetClient.deviceBlock = nil;
    self.packetClient.authStateChangedBlock = nil;
    self.packetClient.requestAuthBlock = nil;
    
    self.packetClient = nil;
}

#pragma mark - 数据封装+解析
// 发送数据，内部做统一的结构封装
- (void)sendPacketData:(id)data
                  type:(ECOPacketDataType)type
                plugin:(__kindof ECOBasePlugin *)plugin
              toDevice:(ECOChannelDeviceInfo *)device {
    //拼装数据
    NSMutableDictionary *packetDict = [NSMutableDictionary dictionary];
    [packetDict setValue:[plugin toDictionary] forKey:@"plugin"];
    
    if ([data isKindOfClass:[NSData class]]) {
        //如果外部数据源是NSData结构，强制以ECOPacketDataType_Data发送
        type = ECOPacketDataType_Data;
    }
    
    if (type == ECOPacketDataType_JSON) {
        [packetDict setValue:data forKey:@"data"];
        NSData *packetData = nil;
        @try {
            packetData = [NSKeyedArchiver archivedDataWithRootObject:packetDict];
            if (!packetData) {
                NSError *error = nil;
                packetData = [NSJSONSerialization dataWithJSONObject:packetDict options:0 error:&error];
                if (error) {
                    NSLog(@">>[ECOCoreManager] send packetData failed:%@", error);
                }
            }
        } @catch (NSException *exception) {
            NSLog(@">>[ECOCoreManager] archive packetData failed:%@", exception);
        }
        [self.packetClient sendPacket:packetData type:ECOPacketDataType_JSON extraInfo:nil plugin:plugin toDevice:device];
    }else{
        if (![data isKindOfClass:[NSData class]]) {
            NSLog(@">>[ECOCoreManager] not valid NSData");
            return;
        }
        [self.packetClient sendPacket:data type:ECOPacketDataType_Data extraInfo:packetDict plugin:plugin toDevice:device];
    }
}
//接收到数据
- (void)device:(ECOChannelDeviceInfo *)device receivedPacketData:(NSData *)data extraInfo:(NSDictionary *)extraInfo {
    if (extraInfo) {
        //普通数据
        ECOBasePlugin *plugin = [[ECOBasePlugin alloc] initWithDictionary:extraInfo[@"plugin"]];
//        ECOPacketProjectModel *projectModel = nil;
//        if (extraInfo[@"project"]) {
//            projectModel = [[ECOPacketProjectModel alloc] initWithDictionary:extraInfo[@"project"]];
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ECOPluginsManager shared] dispatchDevice:device plugin:plugin packet:data];
        });
    }else{
        //json数据
        NSDictionary *jsonObject = nil;
        @try {
            jsonObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (!jsonObject) {
                NSError *error = nil;
                jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (error) {
                    NSLog(@">>[ECOCoreManager] parse received packetData failed:%@", error);
                }
            }
        } @catch (NSException *exception) {
            NSLog(@">>[ECOCoreManager] parse packetData failed:%@", exception);
        }
        if (!jsonObject || ![jsonObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@">>[ECOCoreManager] received packetData invalid");
            return;
        }
        ECOBasePlugin *plugin = [[ECOBasePlugin alloc] initWithDictionary:jsonObject[@"plugin"]];
//        ECOPacketProjectModel *projectModel = nil;
//        if (jsonObject[@"project"]) {
//            projectModel = [[ECOPacketProjectModel alloc] initWithDictionary:jsonObject[@"project"]];
//        }
        id packetData = jsonObject[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ECOPluginsManager shared] dispatchDevice:device plugin:plugin packet:packetData];
        });
    }
}

//设备授权状态发生变更
- (void)device:(ECOChannelDeviceInfo *)device didChangedAuthStatus:(BOOL)isAuthed {
    [[ECOPluginsManager shared] device:device didChangedAuthState:isAuthed];
}

//发送授权数据
- (void)sendAuthorizationMessageToDevice:(ECOChannelDeviceInfo *)device
                                    state:(ECOAuthorizeResponseType)responseType
                           showAuthAlert:(BOOL)showAuthAlert {
    if (!device) {
        return;
    }
    [self.packetClient sendAuthorizationMessageToDevice:device state:responseType showAuthAlert:showAuthAlert];
}

//链接IP地址的主机
- (void)connectToClientIPAddress:(NSString *)ipAddress {
    [self.packetClient connectToClientIPAddress:ipAddress];
}

@end
