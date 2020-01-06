//
//  ECOCoreManager.h
//  Echo
//
//  Created by 陈爱彬 on 2019/4/24. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>
#import "ECOChannelDeviceInfo.h"
#import "ECOBasePlugin.h"
#import "ECOPacketClient.h"

typedef void(^ECOManagerConnectDeviceBlock)(ECOChannelDeviceInfo *device, BOOL isConnected);

typedef void(^ECOManagerAuthStateChangedBlock)(ECOChannelDeviceInfo *device, BOOL authState);
typedef void(^ECOManagerRequestAuthStateBlock)(ECOChannelDeviceInfo *device, BOOL authState);

@interface ECOCoreManager : NSObject

@property (nonatomic, copy) ECOManagerConnectDeviceBlock deviceBlock;
@property (nonatomic, copy) ECOManagerAuthStateChangedBlock authStateChangedBlock;
@property (nonatomic, copy) ECOManagerRequestAuthStateBlock requestAuthBlock;

+ (instancetype)shared;

- (void)start;

- (void)stop;

/**
 发送数据，内部做统一的结构封装

 @param data 要发送的数据，NSDictionary或者NSArray结构体
 @param type 数据类型，json或者普通数据内容
 @param plugin 插件
 @param device 要接收消息的设备，如果传入nil，则对所有已授权连接的设备发送消息
 */
- (void)sendPacketData:(id)data
                  type:(ECOPacketDataType)type
                plugin:(__kindof ECOBasePlugin *)plugin
              toDevice:(ECOChannelDeviceInfo *)device;

//发送授权数据
- (void)sendAuthorizationMessageToDevice:(ECOChannelDeviceInfo *)device
                                    state:(ECOAuthorizeResponseType)responseType
                           showAuthAlert:(BOOL)showAuthAlert;

//链接IP地址的主机
- (void)connectToClientIPAddress:(NSString *)ipAddress;

@end
