//
//  ECOPluginItemsViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/30. Maintain by 陈爱彬
//  Description 
//

#import "ECOPluginItemsViewController.h"
#import <Masonry/Masonry.h>
#import "ECOPluginTableCellView.h"
#import "ECOProjectModel.h"
#import "ECOPacketsDispatcher.h"
#import "ECOUITemplateMapper.h"
#import "ECOPluginItemsOutlineView.h"
#import <EchoSDK/ECOCoreManager.h>

@interface ECOPluginItemsViewController ()
<NSTableViewDelegate,
NSTableViewDataSource,
NSOutlineViewDataSource,
NSOutlineViewDelegate,
NSMenuDelegate>

@property (nonatomic, strong) NSMutableArray *plugins;
@property (weak) IBOutlet NSBox *headerBox;
@property (weak) IBOutlet ECOPluginItemsOutlineView *outlineView;
@property (nonatomic, strong) NSMutableArray *projects;
@property (nonatomic, assign) NSInteger previousIndex;

@end

@implementation ECOPluginItemsViewController

- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.previousIndex = -1;
    [self setupViews];
}

#pragma mark - View视图
- (void)setupViews {
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(100);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    self.headerBox.hidden = YES;
}

#pragma mark - Public methods
- (void)refresh {
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refresh];
        });
        return;
    }
    self.projects = [ECOPacketsDispatcher shared].selectedDevice.projects;
    [self.outlineView reloadData];
    //header控制
//    ECODeviceModel *deviceModel = [ECOPacketsDispatcher shared].selectedDevice;
//    if (deviceModel.deviceInfo.authorizedType == ECOAuthorizeResponseType_Deny) {
//        self.headerBox.hidden = YES;
//        self.outlineView.hidden = YES;
//    }else{
//        self.headerBox.hidden = self.projects.count == 0;
//        self.outlineView.hidden = NO;
//    }
    self.headerBox.hidden = self.projects.count == 0;
    //展开
    [self.outlineView collapseItem:nil];//传nil会关闭root下所有节点
    ECOProjectModel *selectedProject = [ECOPacketsDispatcher shared].selectedDevice.selectedProject;
    //通过animator来添加过渡动画
    [[self.outlineView animator] expandItem:selectedProject];
}
#pragma mark - NSOutlineViewDataSource methods
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (!item) {
        //根节点
        return self.projects.count;
    }
    ECOProjectModel *project = (ECOProjectModel *)item;
    if (project.deviceInfo.authorizedType == ECOAuthorizeResponseType_Deny) {
        return 0;
    }
    return project.plugins.count;
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (!item) {
        //根节点
        return self.projects[index];
    }
    ECOProjectModel *project = (ECOProjectModel *)item;
    if (project.deviceInfo.authorizedType == ECOAuthorizeResponseType_Deny) {
        return nil;
    }
    return project.plugins[index];
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if ([item isKindOfClass:[ECOProjectModel class]]) {
        return YES;
    }
    return NO;
}
#pragma mark - NSOutlineViewDelegate methods
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    ECOPluginTableCellView *cellView = [outlineView makeViewWithIdentifier:@"pluginItemCell" owner:self];
    ECOProjectModel *selectedProject = [ECOPacketsDispatcher shared].selectedDevice.selectedProject;
    if ([item isKindOfClass:[ECOProjectModel class]]) {
        ECOProjectModel *projectModel = (ECOProjectModel *)item;
        cellView.title = projectModel.deviceInfo.appInfo.appName;
        cellView.appIcon = projectModel.deviceInfo.appInfo.appIcon;
        cellView.isSelected = (item == selectedProject);
        BOOL showTriangle = projectModel.deviceInfo.authorizedType != ECOAuthorizeResponseType_Deny && projectModel.plugins.count > 0;
        cellView.showTriangle = showTriangle;
        cellView.rootNode = YES;
    }else if ([item isKindOfClass:[ECOPluginModel class]]) {
        ECOPluginModel *pluginModel = (ECOPluginModel *)item;
        cellView.title = pluginModel.plugin.name;
        ECOPluginModel *selectedPlugin = selectedProject.selectedPlugin;
        cellView.isSelected = (item == selectedPlugin);
        cellView.rootNode = NO;
        cellView.pluginDefaultIcon = ECOPluginDefaultIconFromTemplateType(pluginModel.plugin.templateName);
        cellView.pluginSelectedIcon = ECOPluginSelectedIconFromTemplateType(pluginModel.plugin.templateName);
    }
    [cellView refreshView];
    
    return cellView;
}
- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    return 45;
}
- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSInteger selectedIndex = self.outlineView.selectedRow;
    if (selectedIndex != -1 &&
        selectedIndex != self.previousIndex) {
        id item = [self.outlineView itemAtRow:selectedIndex];
        if ([item isKindOfClass:[ECOProjectModel class]]) {
            ECOProjectModel *projectModel = (ECOProjectModel *)item;
            [ECOPacketsDispatcher shared].selectedDevice.selectedProject = projectModel;
        }else if ([item isKindOfClass:[ECOPluginModel class]]) {
            ECOPluginModel *pluginModel = (ECOPluginModel *)item;
            [ECOPacketsDispatcher shared].selectedDevice.selectedProject.selectedPlugin = pluginModel;
        }
        !self.selectedBlock ?: self.selectedBlock();
        [self refresh];
        self.previousIndex = selectedIndex;
    }
}
#pragma mark - NSMenuDelegate Methods
- (void)menuNeedsUpdate:(NSMenu *)menu {
    [menu removeAllItems];
    //添加新的item
    id item = [self.outlineView itemAtRow:self.outlineView.menuRow];
    if (![item isKindOfClass:[ECOProjectModel class]]) {
        return;
    }
    ECOProjectModel *itemModel = (ECOProjectModel *)item;
    //TODO:判断设备链接状态，添加重连选项
    BOOL isConnected = YES;
    if (isConnected) {
        if (itemModel.deviceInfo.authorizedType != ECOAuthorizeResponseType_Deny) {
            NSMenuItem *disconnectItem = [[NSMenuItem alloc] initWithTitle:@"断开连接" action:@selector(onMenuDisconnectClicked) keyEquivalent:@""];
            [menu addItem:disconnectItem];
        }else{
            NSMenuItem *connectItem = [[NSMenuItem alloc] initWithTitle:@"连接" action:@selector(onMenuConnectClicked) keyEquivalent:@""];
            [menu addItem:connectItem];
        }
    }else{
        NSMenuItem *reconnectItem = [[NSMenuItem alloc] initWithTitle:@"重连" action:@selector(onMenuReConnectedClicked) keyEquivalent:@""];
        [menu addItem:reconnectItem];
    }
}
//断开连接
- (void)onMenuDisconnectClicked {
    id item = [self.outlineView itemAtRow:self.outlineView.menuRow];
    if (![item isKindOfClass:[ECOProjectModel class]]) {
        return;
    }
    ECOProjectModel *itemModel = (ECOProjectModel *)item;
    [[ECOCoreManager shared] sendAuthorizationMessageToDevice:itemModel.deviceInfo state:ECOAuthorizeResponseType_Deny showAuthAlert:NO];
}
//连接
- (void)onMenuConnectClicked {
    id item = [self.outlineView itemAtRow:self.outlineView.menuRow];
    if (![item isKindOfClass:[ECOProjectModel class]]) {
        return;
    }
    ECOProjectModel *itemModel = (ECOProjectModel *)item;
    [[ECOCoreManager shared] sendAuthorizationMessageToDevice:itemModel.deviceInfo state:ECOAuthorizeResponseType_AllowAlways showAuthAlert:YES];
}
//断开后重连
- (void)onMenuReConnectedClicked {
    
}
#pragma mark - getters
- (NSMutableArray *)plugins {
    if (!_plugins) {
        _plugins = [NSMutableArray array];
    }
    return _plugins;
}

@end
