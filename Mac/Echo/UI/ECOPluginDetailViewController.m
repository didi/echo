//
//  ECOPluginDetailViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/29. Maintain by 陈爱彬
//  Description 
//

#import "ECOPluginDetailViewController.h"
#import <Masonry/Masonry.h>
#import "ECOPacketsDispatcher.h"
#import "ECOPluginUIProtocol.h"
#import "ECOUITemplateMapper.h"
#import "ECODeviceModel.h"
#import "ECODeviceConnectView.h"
#import "ECOCoreManager.h"

@interface ECOPluginDetailViewController ()

@property (nonatomic, strong) NSMutableArray *plugins;
@property (nonatomic, copy) NSMutableArray *unComplatiblePlugins;
@property (nonatomic, strong) ECODeviceConnectView *connectView;
@end

@implementation ECOPluginDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.tabStyle = NSTabViewControllerTabStyleUnspecified;
    self.transitionOptions = NSViewControllerTransitionNone;
}

- (void)appendPlugin:(__kindof ECOBasePlugin *)plugin {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.plugins containsObject:plugin]) {
            return;
        }
        BOOL canAdd = [self addTabWithPlugin:plugin];
        if (canAdd) {
            [self.plugins addObject:plugin];
        }
    });
}
#pragma mark - Public methods
- (void)refreshWithFlag:(BOOL)refreshDetail {
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshWithFlag:refreshDetail];
        });
        return;
    }
    //刷新UI
    ECOProjectModel *projectModel = [ECOPacketsDispatcher shared].selectedDevice.selectedProject;
    [self showConnectViewWithProject:projectModel];

    ECOPluginModel *pluginModel = projectModel.selectedPlugin;
    __kindof ECOBasePlugin *selectedPlugin = pluginModel.plugin;
    if (!selectedPlugin) {
        self.tabView.hidden = YES;
        return;
    }
    
    if (![self.plugins containsObject:selectedPlugin]) {
        BOOL canAdd = [self addTabWithPlugin:selectedPlugin];
        if (canAdd) {
            [self.plugins addObject:selectedPlugin];
        }
    }
    [self selectPlugin:selectedPlugin];
    
    if (refreshDetail) {
        [self refreshUI];
    }
}
#pragma mark - Tab管理
- (BOOL)addTabWithPlugin:(__kindof ECOBasePlugin *)plugin {
    if (!plugin.templateName) {
        return NO;
    }
    NSString *clsName = ECOViewControllerFromTemplateType(plugin.templateName);
    if (!clsName) {
        return NO;
    }
    Class cls = NSClassFromString(clsName);
    NSViewController *vc = [[cls alloc] initWithNibName:nil bundle:nil];
    if (vc != nil) {
        if ([vc conformsToProtocol:@protocol(ECOPluginUIProtocol)]) {
            if ([vc respondsToSelector:@selector(setPlugin:)]) {
                [vc performSelector:@selector(setPlugin:) withObject:plugin];
            }
            if ([vc respondsToSelector:@selector(setTemplateData:)]) {
                [vc performSelector:@selector(setTemplateData:) withObject:plugin.templateData];
            }
        }
        NSTabViewItem *item = [[NSTabViewItem alloc] init];
        item.viewController = vc;
        [self addTabViewItem:item];
        return YES;
    }
    return NO;
}
- (void)selectPlugin:(__kindof ECOBasePlugin *)plugin {
    if (![self.plugins containsObject:plugin]) {
        return;
    }
    NSInteger selectedIndex = NSNotFound;
    for (NSInteger i = 0; i < self.plugins.count; i++) {
        __kindof ECOBasePlugin *ePlugin = self.plugins[i];
        if ([ePlugin.name isEqualToString:plugin.name]) {
            selectedIndex = i;
            break;
        }
    }
    if (selectedIndex != NSNotFound &&
        selectedIndex != self.selectedTabViewItemIndex) {
        self.selectedTabViewItemIndex = selectedIndex;
        NSTabViewItem *item = self.tabViewItems[self.selectedTabViewItemIndex];
        if (item.viewController != nil) {
            [item.viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.top.bottom.mas_equalTo(0);
            }];
        }
        //检测是否兼容
        [self checkPluginIsCompatibleWithItem:item forceShow:YES];
    }
}
//刷新当前Tab的UI
- (void)refreshUI {
    if (self.selectedTabViewItemIndex == -1) {
        return;
    }
    NSTabViewItem *selectedItem = self.tabViewItems[self.selectedTabViewItemIndex];
    if (selectedItem.viewController && [selectedItem.viewController conformsToProtocol:@protocol(ECOPluginUIProtocol)]) {
        ECOPluginModel *pluginModel = [ECOPacketsDispatcher shared].selectedDevice.selectedProject.selectedPlugin;
        if ([self.unComplatiblePlugins containsObject:pluginModel.plugin.name]) {
            return;
        }
        BOOL isCompatible = [self checkPluginIsCompatibleWithItem:selectedItem forceShow:NO];
        if (!isCompatible) {
            return;
        }
        if ([selectedItem.viewController respondsToSelector:@selector(refreshWithPackets:)]) {
            NSArray *packetList = [pluginModel packetList];
            [selectedItem.viewController performSelector:@selector(refreshWithPackets:) withObject:packetList];
        }
    }
}
- (BOOL)checkPluginIsCompatibleWithItem:(NSTabViewItem *)item
                              forceShow:(BOOL)isForce {
    BOOL isCompatible = YES;
    if (item.viewController && [item.viewController conformsToProtocol:@protocol(ECOPluginUIProtocol)]) {
        if ([item.viewController respondsToSelector:@selector(isPluginCompatible)]) {
            NSMethodSignature *signature = [item.viewController methodSignatureForSelector:@selector(isPluginCompatible)];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:item.viewController];
            [invocation setSelector:@selector(isPluginCompatible)];
            [invocation getReturnValue:&isCompatible];
            if (!isCompatible) {
                //alert提示
                [self showPluginNotCompatibleAlert:isForce];
            }
        }
    }
    return isCompatible;
}
- (void)showPluginNotCompatibleAlert:(BOOL)isForce {
    ECOPluginModel *pluginModel = [ECOPacketsDispatcher shared].selectedDevice.selectedProject.selectedPlugin;
    if (!isForce) {
        if ([self.unComplatiblePlugins containsObject:pluginModel.plugin.name]) {
            return;
        }
    }
    [self.unComplatiblePlugins addObject:pluginModel.plugin.name];
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSInformationalAlertStyle;
    [alert addButtonWithTitle:@"确定"];
    alert.messageText = @"提示";
    alert.informativeText = [NSString stringWithFormat:@"当前Echo版本不兼容 %@ 插件，请升级Echo客户端或者更新SDK。", pluginModel.plugin.name];
    
    NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
    [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            NSLog(@"确定");
        } else if (returnCode == NSAlertSecondButtonReturn) {
            NSLog(@"取消");
        } else {
            NSLog(@"其他按钮");
        }
    }];
}
#pragma mark - 设备连接
- (void)showConnectViewWithProject:(ECOProjectModel *)project {
    if (![project isKindOfClass:[ECOProjectModel class]]) {
        return;
    }
    if (project.deviceInfo.authorizedType != ECOAuthorizeResponseType_Deny) {
        //已授权
        self.tabView.hidden = NO;
        _connectView.hidden = YES;
        _connectView.connectBlock = nil;
    }else{
        //未授权
        self.tabView.hidden = YES;
        self.connectView.hidden = NO;
        self.connectView.projectInfo = project;
        __weak typeof(ECOCoreManager) *weakManager = [ECOCoreManager shared];
        self.connectView.connectBlock = ^(ECOProjectModel *project) {
            [weakManager sendAuthorizationMessageToDevice:project.deviceInfo state:ECOAuthorizeResponseType_AllowAlways showAuthAlert:YES];
        };
    }
}
#pragma mark - getters
- (NSMutableArray *)plugins {
    if (!_plugins) {
        _plugins = [NSMutableArray array];
    }
    return _plugins;
}
- (NSMutableArray *)unComplatiblePlugins {
    if (!_unComplatiblePlugins) {
        _unComplatiblePlugins = [NSMutableArray array];
    }
    return _unComplatiblePlugins;
}
- (ECODeviceConnectView *)connectView {
    if (!_connectView) {
        _connectView = [[ECODeviceConnectView alloc] initWithFrame:NSMakeRect(50, 100, 200, 200)];
        [self.view addSubview:_connectView];
        [_connectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _connectView;
}
@end
