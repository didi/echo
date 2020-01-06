//
//  ECOTemplateH5ViewController.h
//  Echo
//
//  Created by 陈爱彬 on 2019/8/6. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>
#import "ECOPluginUIProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ECOTemplateH5ViewController : NSViewController
<ECOPluginUIProtocol>

@property (nonatomic, weak) __kindof ECOBasePlugin *plugin;

- (void)receivedJSMessage:(id)result;

@end

NS_ASSUME_NONNULL_END
