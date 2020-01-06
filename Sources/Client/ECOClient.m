//
//  ECOClient.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/29. Maintain by 陈爱彬
//  Description 
//

#import "ECOClient.h"
#import "ECOPluginsManager.h"
#import "ECOCoreManager.h"

@interface ECOClient()

@property (nonatomic, strong) NSMutableArray *plugins;

@end

@implementation ECOClient

#pragma mark - Lifecycle methods
+ (instancetype)sharedClient {
    static ECOClient *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ECOClient alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.plugins = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public methods
//启动服务
- (void)start {
    [self startWithConfig:nil];
}

- (void)startWithConfig:(ECOClientConfig *)config {
    _config = config;
    
    for (Class cls in self.plugins) {
        ECOBasePlugin *plugin = [[cls alloc] init];
        [[ECOPluginsManager shared] registerPlugin:plugin];
    }
        
#if TARGET_OS_IPHONE
    ECOCoreManager *manager = [ECOCoreManager shared];
    [ECOChannelAppInfo setUniqueAppId:_config.appId appName:_config.appName];
    
    __weak typeof(manager) weakManager = manager;
    manager.requestAuthBlock = ^(ECOChannelDeviceInfo *device, BOOL authState) {
        NSString *title = @"Echo 连接请求";
        NSString *message = [NSString stringWithFormat:@"%@ 的Echo想要连接你的设备，如果你想启用调试功能，请选择允许", device.hostName ?: device.ipAddress];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *denyAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakManager sendAuthorizationMessageToDevice:device state:ECOAuthorizeResponseType_Deny showAuthAlert:NO];
        }];
        UIAlertAction *allowAlwaysAction = [UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakManager sendAuthorizationMessageToDevice:device state:ECOAuthorizeResponseType_AllowAlways showAuthAlert:NO];
        }];
        [alertController addAction:denyAction];
        [alertController addAction:allowAlwaysAction];
        
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC presentViewController:alertController animated:YES completion:nil];
    };
#endif
    [[ECOCoreManager shared] start];
}

// 停止服务
- (void)stop {
    [[ECOPluginsManager shared] clearPlugins];
    [[ECOCoreManager shared] stop];
}

- (void)registerPlugin:(Class)plugin {
    if (plugin) {
        [self.plugins addObject:plugin];
    }
}

@end
