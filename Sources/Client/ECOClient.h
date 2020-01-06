//
//  ECOClient.h
//  Echo
//
//  Created by 陈爱彬 on 2019/4/29. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>
#import "ECOClientConfig.h"

@interface ECOClient : NSObject

/**
 EchoSDK配置
 */
@property (nonatomic, strong, readonly) ECOClientConfig *config;

+ (instancetype)sharedClient;

/**
 启动服务
 */
- (void)start;

- (void)startWithConfig:(ECOClientConfig *)config;

/**
 停止服务
 */
- (void)stop;

/**
 注册插件

 @param plugin 插件Class
 */
- (void)registerPlugin:(Class)plugin;

@end
