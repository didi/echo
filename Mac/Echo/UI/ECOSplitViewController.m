//
//  ECOSplitViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/29. Maintain by 陈爱彬
//  Description 
//

#import "ECOSplitViewController.h"
#import "ECODevicesListViewController.h"
#import "ECOPluginItemsViewController.h"
#import "ECOPluginDetailViewController.h"
#import "ECOPluginUIProtocol.h"
#import "ECOPacketsDispatcher.h"

@interface ECOSplitViewController ()
<NSSplitViewDelegate>

@property (nonatomic, weak) ECODevicesListViewController *deviceVC;
@property (nonatomic, weak) ECOPluginItemsViewController *pluginsVC;
@property (nonatomic, weak) ECOPluginDetailViewController *detailVC;
@end

@implementation ECOSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.splitView.wantsLayer = YES;
    self.splitView.layer.masksToBounds = YES;
    self.splitView.layer.cornerRadius = 40.f;
    
    [self setupUIObserver];
}

- (void)setupUIObserver {

    NSArray<__kindof NSSplitViewItem *> *splitItems = self.splitViewItems;
    self.deviceVC = (ECODevicesListViewController *)splitItems.firstObject.viewController;
    self.pluginsVC = (ECOPluginItemsViewController *)splitItems[1].viewController;
    self.detailVC = (ECOPluginDetailViewController *)splitItems.lastObject.viewController;
    __weak typeof(self) weakSelf = self;
    self.deviceVC.selectedBlock = ^{
        [weakSelf.pluginsVC refresh];
        [weakSelf.detailVC refreshWithFlag:YES];
    };
    self.deviceVC.connectBlock = ^(ECODeviceModel *deviceInfo) {
        [weakSelf.pluginsVC refresh];
        [weakSelf.detailVC refreshWithFlag:YES];
    };
    self.pluginsVC.selectedBlock = ^{
        [weakSelf.detailVC refreshWithFlag:YES];
    };
    [ECOPacketsDispatcher shared].refreshBlock = ^(BOOL refreshDevice, BOOL refreshPlugin, BOOL refreshDetail) {
        if (refreshDevice) {
            [weakSelf.deviceVC refresh];
        }
        if (refreshPlugin) {
            [weakSelf.pluginsVC refresh];
        }
        [weakSelf.detailVC refreshWithFlag:refreshDetail];
    };
}


#pragma mark - NSSplitViewDelegate
- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex {
    return YES;
}


@end
