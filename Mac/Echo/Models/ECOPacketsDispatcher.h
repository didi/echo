//
//  ECOPacketsDispatcher.h
//  Echo
//
//  Created by 陈爱彬 on 2019/5/16. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>
#import "ECOChannelDeviceInfo.h"
#import "ECODeviceModel.h"
#import "ECOBasePlugin.h"

typedef void(^ECOPacketsRefreshBlock)(BOOL refreshDevice, BOOL refreshPlugin, BOOL refreshDetail);

@interface ECOPacketsDispatcher : NSObject

@property (nonatomic, strong) NSMutableArray<ECODeviceModel *> *devices;
@property (nonatomic, strong) ECODeviceModel *selectedDevice;
@property (nonatomic, copy) ECOPacketsRefreshBlock refreshBlock;
@property (nonatomic, strong) NSMutableArray<ECODeviceModel *> *authorizedDevices;
@property (nonatomic, strong) NSMutableArray<ECODeviceModel *> *discoverdDevices;

@property (nonatomic, strong) ECOChannelDeviceInfo *hostDevice;

+ (instancetype)shared;

//清空当前插件的数据
- (void)clearCurrentPluginPackets;

- (void)device:(ECOChannelDeviceInfo *)device didUpdateToState:(BOOL)isConnected;

@end
