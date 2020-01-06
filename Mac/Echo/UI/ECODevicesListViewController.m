//
//  ECODevicesListViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/5/14. Maintain by 陈爱彬
//  Description 
//

#import "ECODevicesListViewController.h"
#import <Masonry/Masonry.h>
#import "ECODeviceTableCellView.h"
#import "ECOPacketsDispatcher.h"
#import "ECONoTriangleOutlineView.h"
//#import "ECODeviceModel.h"
#import <EchoSDK/ECOCoreManager.h>

static NSString *const kNoConnectedDevicesDefaultName = @"No device connected";

@interface ECODevicesListViewController ()
<NSOutlineViewDataSource,
NSOutlineViewDelegate>

@property (weak) IBOutlet NSView *logoView;
@property (weak) IBOutlet ECONoTriangleOutlineView *outlineView;
@property (weak) IBOutlet NSButton *guideButton;
@property (nonatomic, strong) NSMutableArray *devicesList;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation ECODevicesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupViews];
}

#pragma mark - View视图
- (void)setupViews {
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(100);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    self.selectedIndex = NSNotFound;
    self.devicesList = @[].mutableCopy;
    [self.devicesList addObject:@{@"title": kNoConnectedDevicesDefaultName}];
    [self.outlineView reloadData];
    //请设置完54行的url后再注释掉该行
    self.guideButton.hidden = YES;
}
//点击了新手引导
- (IBAction)clickedGuideButton:(NSButton *)sender {
//    NSString *urlString = @"please enter your guide url";
//    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}
//点击了添加设备
- (IBAction)clickedAddDeviceButton:(NSButton *)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSAlertStyleInformational];
    [alert setMessageText:@"请输入集成EchoSDK的客户端IP地址并建立连接"];
    [alert addButtonWithTitle:@"连接"];
    [alert addButtonWithTitle:@"取消"];
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [alert setAccessoryView:input];
    __weak typeof(self) weakSelf = self;
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        [input validateEditing];
        if (returnCode == -NSModalResponseStop) {
            NSString *str = input.stringValue;
            NSString *pattern = @"^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$";
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
            NSArray *match = [regex matchesInString:str options:NSMatchingReportCompletion range: NSMakeRange(0, [str length])];
            if (match.count != 0) {
                [weakSelf addDeviceWithIPAddress:str];
            }
        }
    }];
}
#pragma mark - Public methods
- (void)refresh {
    self.devicesList = @[].mutableCopy;
    NSArray *devices = [ECOPacketsDispatcher shared].devices;
    if (devices.count > 0) {
        NSArray *authorizedDevices = [ECOPacketsDispatcher shared].authorizedDevices;
        NSArray *discoverdDevices = [ECOPacketsDispatcher shared].discoverdDevices;
        [self.devicesList addObject:@{@"title": @"已授权设备",
                                      @"authed": @(1),
                                      @"list": authorizedDevices
                                      }];
        [self.devicesList addObject:@{
                                      @"title": @"未授权设备",
                                      @"authed": @(0),
                                      @"list": discoverdDevices
                                      }];
    }else{
        [self.devicesList addObject:@{@"title": kNoConnectedDevicesDefaultName}];
    }
    [self.outlineView reloadData];
    //通过animator来添加过渡动画
    [[self.outlineView animator] expandItem:nil expandChildren:YES];
    //连接回调
    if (devices.count > 0) {
        ECODeviceModel *device = [ECOPacketsDispatcher shared].selectedDevice;
        !self.connectBlock ?: self.connectBlock(device);
    }
}
#pragma mark - NSOutlineViewDataSource Methods
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (item == nil) {
        return self.devicesList.count;
    }
    NSArray *list = item[@"list"];
    return list.count;
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (item == nil) {
        return self.devicesList[index];
    }
    NSArray *list = item[@"list"];
    return list[index];
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if ([item isKindOfClass:[NSDictionary class]]) {
        NSArray *list = item[@"list"];
        if (list.count > 0) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(id)item {
    return NO;
}
- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    if (item == nil) {
        return 20;
    }
    return 40;
}
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    ECODeviceTableCellView *cell = (ECODeviceTableCellView *)[outlineView makeViewWithIdentifier:@"deviceCell" owner:nil];
    if ([item isKindOfClass:[ECODeviceModel class]]) {
        ECODeviceModel *deviceInfo = (ECODeviceModel *)item;
        cell.deviceName = deviceInfo.deviceName;
        cell.isDevice = YES;
        cell.isConnected = deviceInfo.isConnected;
        ECODeviceModel *device = [ECOPacketsDispatcher shared].selectedDevice;
        if ([device.deviceId isEqualToString:deviceInfo.deviceId]) {
            cell.selected = YES;
        }else {
            cell.selected = NO;
        }
    }else if ([item isKindOfClass:[NSDictionary class]]) {
        NSString *groupTitle = item[@"title"];
        cell.deviceName = groupTitle;
        cell.isDevice = NO;
        cell.isAuthorized = [item[@"authed"] boolValue];
    }
    [cell refreshView];
    return cell;

}
#pragma mark - NSOutlineViewDelegate Methods
- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSInteger selectedRow = self.outlineView.selectedRow;
    id item = [self.outlineView itemAtRow:selectedRow];
    if ([item isKindOfClass:[ECODeviceModel class]]) {
        ECODeviceModel *itemDevice = (ECODeviceModel *)item;
        ECODeviceModel *device = [ECOPacketsDispatcher shared].selectedDevice;
        if (![device.deviceId isEqualToString:itemDevice.deviceId]) {
            [ECOPacketsDispatcher shared].selectedDevice = itemDevice;
            [self.outlineView reloadData];
            !self.selectedBlock ?: self.selectedBlock();
            
            !self.connectBlock ?: self.connectBlock(itemDevice);
        }
    }
}

#pragma mark - 添加新设备
- (void)addDeviceWithIPAddress:(NSString *)ipAddress {
    [[ECOCoreManager shared] connectToClientIPAddress:ipAddress];
}

@end
