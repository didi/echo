//
//  ECODeviceConnectView.h
//  Echo
//
//  Created by 陈爱彬 on 2019/9/24. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>
#import "ECOProjectModel.h"

typedef void(^ECOAuthorizeConnectBlock)(ECOProjectModel *project);

@interface ECODeviceConnectView : NSView

@property (nonatomic, strong) ECOProjectModel *projectInfo;
@property (nonatomic, copy) ECOAuthorizeConnectBlock connectBlock;

@end
