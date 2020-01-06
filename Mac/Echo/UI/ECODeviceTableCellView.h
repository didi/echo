//
//  ECODeviceTableCellView.h
//  Echo
//
//  Created by 陈爱彬 on 2019/5/15. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>

@interface ECODeviceTableCellView : NSTableCellView

@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, assign) BOOL isConnected;

@property (nonatomic, assign) BOOL isDevice;
@property (nonatomic, assign) BOOL isAuthorized;

- (void)refreshView;

@end
