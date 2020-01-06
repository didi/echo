//
//  ECODevicesListViewController.h
//  Echo
//
//  Created by 陈爱彬 on 2019/5/14. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>
#import "ECOChannelDeviceInfo.h"

@class ECODeviceModel;
typedef void(^ECODeviceSelectedChangedBlock)(void);
typedef void(^ECODeviceConnectedBlock)(ECODeviceModel *deviceInfo);

@interface ECODevicesListViewController : NSViewController

@property (nonatomic, copy) ECODeviceSelectedChangedBlock selectedBlock;
@property (nonatomic, copy) ECODeviceConnectedBlock connectBlock;

- (void)refresh;

@end
