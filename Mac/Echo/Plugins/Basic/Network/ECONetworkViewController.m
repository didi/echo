//
//  ECONetworkViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/3. Maintain by 陈爱彬
//  Description 
//

#import "ECONetworkViewController.h"
#import "ECOTemplateTableHeaderCell.h"
#import "ECOPluginModel.h"
#import "ECOPacketsDispatcher.h"
#import <Masonry/Masonry.h>
#import "ECONetworkDetailViewController.h"
#import "ECONetworkListTableCellView.h"

@interface ECONetworkViewController ()
<NSTableViewDataSource,
NSTableViewDelegate,
NSSearchFieldDelegate>

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSBox *searchBox;
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSBox *detailBox;

@property (nonatomic, strong) NSArray *requestsArray;
@property (nonatomic, strong) ECONetworkDetailViewController *detailVC;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation ECONetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.selectedIndex = -1;
    [self setupViews];
}

//设置视图效果
- (void)setupViews {
    self.searchBox.cornerRadius = 0.f;
    self.searchBox.borderColor = [NSColor clearColor];
    self.searchBox.borderWidth = 0.f;
    
    self.scrollView.wantsLayer = YES;
    self.scrollView.layer.cornerRadius = 15.f;
    self.scrollView.contentView.wantsLayer = YES;
    self.scrollView.contentView.layer.cornerRadius = 15.f;
    self.scrollView.layer.shadowColor = [NSColor colorWithWhite:0 alpha:0.6].CGColor;
    self.scrollView.layer.shadowOffset = CGSizeMake(0, 3);
    self.scrollView.layer.shadowOpacity = 0.6;
    self.scrollView.layer.shadowRadius = 3;

    //Header标题
    for (NSTableColumn *column in self.tableView.tableColumns) {
        if ([column.identifier isEqualToString:@"statusCodeColumn"]) {
            column.headerCell = [[ECOTemplateTableHeaderCell alloc] initTextCell:@"StatusCode"];
        }else if ([column.identifier isEqualToString:@"methodColumn"]) {
            column.headerCell = [[ECOTemplateTableHeaderCell alloc] initTextCell:@"Method"];
        }else if ([column.identifier isEqualToString:@"urlColumn"]) {
            column.headerCell = [[ECOTemplateTableHeaderCell alloc] initTextCell:@"URL"];
        }else if ([column.identifier isEqualToString:@"dateColumn"]) {
            column.headerCell = [[ECOTemplateTableHeaderCell alloc] initTextCell:@"Date"];
        }
    }
    //设置详细视图
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"ECONetworkDetailViewController" bundle:nil];
    self.detailVC = [storyBoard instantiateControllerWithIdentifier:@"detailVC"];
    [self.detailBox addSubview:self.detailVC.view];
    [self.detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)viewDidAppear {
    //修改divider位置，在viewDidLoad里调用相当于添加完视图立即修改位置，会无效果
    CGFloat dividerPosition = self.view.bounds.size.height * 0.5;
    CGFloat maxPosition = [self.splitView maxPossiblePositionOfDividerAtIndex:0];
    [self.splitView setPosition:MIN(dividerPosition, maxPosition) ofDividerAtIndex:0];
}

#pragma mark - ECOPluginUIProtocol methods
- (void)refreshWithPackets:(NSArray *)packets {
    NSString *searchKey = self.searchField.stringValue;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ECOPluginModel *pluginModel = [ECOPacketsDispatcher shared].selectedDevice.selectedProject.selectedPlugin;
        NSArray *packetList = [pluginModel packetList];
        NSMutableArray *list = [NSMutableArray array];
        if (searchKey.length > 0) {
            list = [NSMutableArray array];
            for (NSDictionary *dict in packetList) {
                NSString *url = dict[@"url"];
                if ([url containsString:searchKey]) {
                    [list addObject:dict];
                }
            }
        }else{
            list = [NSMutableArray arrayWithArray:packetList];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.requestsArray = list;
            [self.tableView reloadData];
            if (self.selectedIndex >= 0) {
                [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:self.selectedIndex] byExtendingSelection:NO];
            }
            [self.tableView scrollToEndOfDocument:nil];
        });
    });
}

#pragma mark - NSTableViewDataSource methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.requestsArray.count;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSDictionary *item = self.requestsArray[row];
    if ([tableColumn.identifier isEqualToString:@"statusCodeColumn"]) {
        ECONetworkListTableCellView *cell = [tableView makeViewWithIdentifier:@"statusCodeCell" owner:nil];
        cell.content = item[@"code"] ?: @"";
        cell.isCellSelected = row == self.selectedIndex;
        return cell;
    }else if ([tableColumn.identifier isEqualToString:@"methodColumn"]) {
        ECONetworkListTableCellView *cell = [tableView makeViewWithIdentifier:@"methodCell" owner:nil];
        cell.content = item[@"method"] ?: @"";
        cell.isCellSelected = row == self.selectedIndex;
        return cell;
    }else if ([tableColumn.identifier isEqualToString:@"urlColumn"]) {
        ECONetworkListTableCellView *cell = [tableView makeViewWithIdentifier:@"urlCell" owner:nil];
        cell.content = item[@"url"] ?: @"";
        cell.isCellSelected = row == self.selectedIndex;
        return cell;
    }else if ([tableColumn.identifier isEqualToString:@"dateColumn"]) {
        ECONetworkListTableCellView *cell = [tableView makeViewWithIdentifier:@"dateCell" owner:nil];
        cell.content = item[@"startDate"] ?: @"";
        cell.isCellSelected = row == self.selectedIndex;
        return cell;
    }
    return nil;
}
#pragma mark - NSTableViewDelegate methods
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger selectedRow = self.tableView.selectedRow;
    if (selectedRow == self.selectedIndex &&
        self.selectedIndex != -1) {
        return;
    }
    if (self.selectedIndex >= 0) {
        [self updateCellSelection:NO atRow:self.selectedIndex];
    }
    self.selectedIndex = selectedRow;
    NSDictionary *contentDict = nil;
    if (selectedRow != -1) {
        contentDict = self.requestsArray[selectedRow];

        [self updateCellSelection:YES atRow:self.selectedIndex];
    }
    self.detailVC.detailInfo = contentDict;
}

- (void)updateCellSelection:(BOOL)isSelected atRow:(NSInteger)row {
    if (row < 0) {
        return;
    }
    NSInteger networkColumns = 4;
    for (NSInteger i = 0; i < networkColumns; i++) {
        ECONetworkListTableCellView *cell = [self.tableView viewAtColumn:i row:row makeIfNecessary:NO];
        cell.isCellSelected = isSelected;
    }
}

#pragma mark - NSSearchFieldDelegate methods
- (void)controlTextDidChange:(NSNotification *)obj {
    self.selectedIndex = -1;
    [self refreshWithPackets:nil];
}

#pragma mark - Button Methods
- (IBAction)onDeleteButtonTapped:(NSButton *)sender {
    [[ECOPacketsDispatcher shared] clearCurrentPluginPackets];
    self.selectedIndex = -1;
    [self refreshWithPackets:nil];
    
    NSDictionary *contentDict = nil;
    self.detailVC.detailInfo = contentDict;
}
#pragma mark - getters
- (NSArray *)requestsArray {
    if (!_requestsArray) {
        _requestsArray = [NSArray array];
    }
    return _requestsArray;
}

@end
