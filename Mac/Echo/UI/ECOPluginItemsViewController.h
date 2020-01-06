//
//  ECOPluginItemsViewController.h
//  Echo
//
//  Created by 陈爱彬 on 2019/4/30. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>
#import "ECOBasePlugin.h"

typedef void(^ECOPluginItemSelectedBlock)(void);

@interface ECOPluginItemsViewController : NSViewController

@property (nonatomic, copy) ECOPluginItemSelectedBlock selectedBlock;

- (void)refresh;

@end
