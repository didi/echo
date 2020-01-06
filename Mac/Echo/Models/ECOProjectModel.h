//
//  ECOProjectModel.h
//  Echo
//
//  Created by 陈爱彬 on 2019/5/16. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>
#import "ECOPluginModel.h"
#import <EchoSDK/ECOChannelDeviceInfo.h>
#import <EchoSDK/ECOChannelAppInfo.h>

@interface ECOProjectModel : NSObject

@property (nonatomic, strong) NSMutableArray<ECOPluginModel *> *plugins;
@property (nonatomic, strong) ECOPluginModel *selectedPlugin;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, strong) ECOChannelDeviceInfo *deviceInfo;

- (void)appendPlugin:(ECOPluginModel *)plugin;

- (BOOL)updateWithPlugin:(__kindof ECOBasePlugin *)plugin packet:(id)packetData;

@end

