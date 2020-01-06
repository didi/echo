//
//  ECOPacketClient.h
//  Echo
//
//  Created by 陈爱彬 on 2019/4/24. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>
#import "ECOChannelDeviceInfo.h"
#import "ECOChannelManager.h"
#import "ECOBasePlugin.h"

typedef void(^ECOPacketClientReceivedBlock)(ECOChannelDeviceInfo *device, NSData *data, NSDictionary *extraInfo);
typedef void(^ECOPacketClientDeviceConnectedBlock)(ECOChannelDeviceInfo *device, BOOL isConnected);

typedef void(^ECOPacketClientAuthStateChangedBlock)(ECOChannelDeviceInfo *device, BOOL authState);
typedef void(^ECOPacketClientRequestAuthStateBlock)(ECOChannelDeviceInfo *device, BOOL authState);

@interface ECOPacketClient : NSObject

@property (nonatomic, copy) ECOPacketClientReceivedBlock receivedBlock;
@property (nonatomic, copy) ECOPacketClientDeviceConnectedBlock deviceBlock;

@property (nonatomic, copy) ECOPacketClientAuthStateChangedBlock authStateChangedBlock;
@property (nonatomic, copy) ECOPacketClientRequestAuthStateBlock requestAuthBlock;

//发送数据，data数据由接入层传入
- (void)sendPacket:(NSData *)packet
              type:(ECOPacketDataType)type
         extraInfo:(NSDictionary *)extraInfo
            plugin:(__kindof ECOBasePlugin *)plugin
          toDevice:(ECOChannelDeviceInfo *)device;

//发送授权数据
- (void)sendAuthorizationMessageToDevice:(ECOChannelDeviceInfo *)device
                                    state:(ECOAuthorizeResponseType)responseType
                           showAuthAlert:(BOOL)showAuthAlert;

//链接IP地址的主机
- (void)connectToClientIPAddress:(NSString *)ipAddress;

@end
