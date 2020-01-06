//
//  ECOPluginsManager.h
//  Echo
//
//  Created by 陈爱彬 on 2019/4/23. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>
#import "ECOBasePlugin.h"
#import "ECOChannelDeviceInfo.h"

typedef void(^ECOPluginReceivedDataBlock)(ECOChannelDeviceInfo *device, __kindof ECOBasePlugin *plugin, id packetData);

@interface ECOPluginsManager : NSObject

@property (nonatomic, copy) ECOPluginReceivedDataBlock receivedBlock;

+ (instancetype)shared;

- (void)clearPlugins;

- (void)registerPlugin:(__kindof ECOBasePlugin *)plugin;

//分发数据给对应的插件
- (void)dispatchDevice:(ECOChannelDeviceInfo *)device
                plugin:(__kindof ECOBasePlugin *)plugin
                packet:(id)packetData;

//设备授权状态发生变更
- (void)device:(ECOChannelDeviceInfo *)device didChangedAuthState:(BOOL)isAuthed;

@end
