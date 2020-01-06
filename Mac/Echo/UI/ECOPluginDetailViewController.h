//
//  ECOPluginDetailViewController.h
//  Echo
//
//  Created by 陈爱彬 on 2019/4/29. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>
#import "ECOBasePlugin.h"

@class ECOProjectModel;
@interface ECOPluginDetailViewController : NSTabViewController

- (void)appendPlugin:(__kindof ECOBasePlugin *)plugin;

- (void)selectPlugin:(__kindof ECOBasePlugin *)plugin;

- (void)refreshWithFlag:(BOOL)refreshDetail;

- (void)showConnectViewWithProject:(ECOProjectModel *)project;

@end
