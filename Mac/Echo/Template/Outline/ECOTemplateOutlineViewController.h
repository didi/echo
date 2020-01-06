//
//  ECOTemplateOutlineViewController.h
//  Echo
//
//  Created by 陈爱彬 on 2019/6/21. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>
#import "ECOPluginUIProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ECOTemplateOutlineViewController : NSViewController
<ECOPluginUIProtocol>

@property (nonatomic, weak) __kindof ECOBasePlugin *plugin;

@end

NS_ASSUME_NONNULL_END
