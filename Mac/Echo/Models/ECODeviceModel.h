//
//  ECODeviceModel.h
//  Echo
//
//  Created by 陈爱彬 on 2019/5/15. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>
#import "ECOChannelDeviceInfo.h"
#import "ECOProjectModel.h"
#import "ECOBasePlugin.h"

@interface ECODeviceModel : NSObject

//@property (nonatomic, strong) ECOChannelDeviceInfo *deviceInfo;
@property (nonatomic, strong) NSMutableArray<ECOProjectModel *> *projects;
@property (nonatomic, strong) ECOProjectModel *selectedProject;
@property (nonatomic, assign, getter=isConnected) BOOL connected;
@property (nonatomic, assign) BOOL hasPackets;

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceName;

- (BOOL)updateWithDevice:(ECOChannelDeviceInfo *)deviceInfo plugin:(__kindof ECOBasePlugin *)plugin packet:(id)packetData;

@end
