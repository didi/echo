//
//  ECOTemplateListDetailViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/5/28. Maintain by 陈爱彬
//  Description 
//

#import "ECOTemplateListDetailViewController.h"
#import "ECOTemplateTableHeaderCell.h"
#import "ECOPluginModel.h"
#import "ECOPacketsDispatcher.h"
#import "ECOTemplateListDetailCell.h"
#import <Masonry/Masonry.h>

@interface ECOTemplateListDetailViewController ()
<NSSearchFieldDelegate,
NSTableViewDelegate,
NSTableViewDataSource>

@property (weak) IBOutlet NSBox *searchBox;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSSearchField *searchField;
@property (unsafe_unretained) IBOutlet NSTextView *contentTextView;
@property (weak) IBOutlet NSScrollView *textScrollView;

@property (nonatomic, strong) NSArray *columnsArray;
@property (nonatomic, strong) NSArray *bizArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation ECOTemplateListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.selectedIndex = -1;
    if (self.templateData && [self.templateData isKindOfClass:[NSArray class]]) {
        self.columnsArray = (NSArray *)self.templateData;
    }
    [self setupViews];
}
//设置视图效果
- (void)setupViews {
    //    self.searchBox.fillColor = [NSColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    self.searchBox.cornerRadius = 0.f;
    self.searchBox.borderColor = [NSColor clearColor];
    self.searchBox.borderWidth = 0.f;
    
    self.contentTextView.font = [NSFont systemFontOfSize:12];
    self.contentTextView.textColor = [NSColor colorNamed:@"listDetail_text"];
    self.textScrollView.wantsLayer = YES;
    self.textScrollView.layer.cornerRadius = 15.f;
    self.textScrollView.contentView.wantsLayer = YES;
    self.textScrollView.contentView.layer.cornerRadius = 15.f;

    self.scrollView.wantsLayer = YES;
    self.scrollView.layer.cornerRadius = 15.f;
    self.scrollView.contentView.wantsLayer = YES;
    self.scrollView.contentView.layer.cornerRadius = 15.f;
    self.scrollView.layer.shadowColor = [NSColor colorWithWhite:0 alpha:0.6].CGColor;
    self.scrollView.layer.shadowOffset = CGSizeMake(0, 3);
    self.scrollView.layer.shadowOpacity = 0.6;
    self.scrollView.layer.shadowRadius = 3;

    //配置Column
    CGFloat maxWidth = self.view.frame.size.width;
    if (self.columnsArray && self.columnsArray.count > 0) {
        for (NSInteger i = 0; i < self.columnsArray.count; i++) {
            NSDictionary *item = self.columnsArray[i];
            NSString *identifier = item[@"name"] ?: @"";
            CGFloat weight = [item[@"weight"] floatValue];
            NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:identifier];
            column.width = MAX(weight * maxWidth, 10);
            [self.tableView addTableColumn:column];
        }
    }
    //Header标题
    NSArray *tableColumns = self.tableView.tableColumns;
    for (NSInteger i = 0; i < tableColumns.count; i++) {
        NSTableColumn *column = tableColumns[i];
        id item = nil;
        if (i < self.columnsArray.count) {
            item = self.columnsArray[i];
        }
        if (item && [item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *columnItem = (NSDictionary *)item;
            NSString *title = columnItem[@"name"] ?: @"";
            column.headerCell = [[ECOTemplateTableHeaderCell alloc] initTextCell:title];
            
        }
    }
}

- (void)viewDidAppear {
    [super viewDidAppear];
    //修改divider位置，在viewDidLoad里调用相当于添加完视图立即修改位置，会无效果
    CGFloat dividerPosition = self.view.bounds.size.height * 0.65;
    CGFloat maxPosition = [self.splitView maxPossiblePositionOfDividerAtIndex:0];
    [self.splitView setPosition:MIN(dividerPosition, maxPosition) ofDividerAtIndex:0];
}

#pragma mark - 点击事件
- (IBAction)onClearButtonClicked:(NSButton *)sender {
    [[ECOPacketsDispatcher shared] clearCurrentPluginPackets];
    self.selectedIndex = -1;
    self.contentTextView.string = @"";
    [self refreshWithPackets:nil];
}

#pragma mark - ECOPluginUIProtocol methods
- (void)refreshWithPackets:(NSArray *)packets {
    NSString *searchKey = self.searchField.stringValue;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ECOPluginModel *pluginModel = [ECOPacketsDispatcher shared].selectedDevice.selectedProject.selectedPlugin;
        NSArray *packetList = [pluginModel packetList];
        NSMutableArray *list = [NSMutableArray array];
        if (searchKey.length > 0) {
            for (NSDictionary *dict in packetList) {
                BOOL v = [self isItemShouldFilted:dict searchKey:searchKey];
                if (v) {
                    [list addObject:dict];
                }
            }
        }else{
            list = [NSMutableArray arrayWithArray:packetList];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bizArray = list;
            [self.tableView reloadData];
            if (self.selectedIndex >= 0) {
                [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:self.selectedIndex] byExtendingSelection:NO];
            }
            [self.tableView scrollToEndOfDocument:nil];
        });
    });
}
//判断item是否需要被过滤
- (BOOL)isItemShouldFilted:(NSDictionary *)item searchKey:(NSString *)key {
    if (!key || !key.length) {
        return NO;
    }
    NSDictionary *listItem = item[@"list"];
    for (NSInteger i = 0; i < self.columnsArray.count; i++) {
        NSDictionary *column = self.columnsArray[i];
        NSString *identifier = column[@"name"] ?: @"";
        NSString *cellTitle = listItem[identifier] ?: @"";
        if ([cellTitle containsString:key]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - NSTableViewDataSource methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.bizArray.count;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ECOTemplateListDetailCell *cell = [tableView makeViewWithIdentifier:@"cell" owner:nil];
    if (!cell) {
        cell = [[ECOTemplateListDetailCell alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        cell.identifier = @"cell";
    }
    NSString *identifier = tableColumn.identifier ?: @"";
    NSDictionary *item = self.bizArray[row];
    NSDictionary *listItem = item[@"list"];
    NSString *textString = listItem[identifier] ?: @"";
    cell.title = textString;
    cell.selectedMark = self.selectedIndex == row;
    return cell;
}
#pragma mark - NSTableViewDelegate methods
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger selectedRow = self.tableView.selectedRow;
    if (selectedRow == self.selectedIndex &&
        self.selectedIndex != -1) {
        return;
    }
    //取消当前cell的选中效果
    if (self.selectedIndex >= 0) {
        [self updateCellSelection:NO atRow:self.selectedIndex];
    }
    self.selectedIndex = selectedRow;

    NSDictionary *contentDict = nil;
    if (selectedRow != -1) {
//        NSLog(@"选中了:%@",self.bizArray[selectedRow]);
        contentDict = self.bizArray[selectedRow];
        //刷新选中效果
        [self updateCellSelection:YES atRow:self.selectedIndex];
    }
    NSString *textString = contentDict[@"detail"] ?: @"";
    self.contentTextView.string = textString;
}

- (void)updateCellSelection:(BOOL)isSelected atRow:(NSInteger)row {
    if (row < 0) {
        return;
    }
    for (NSInteger i = 0; i < self.columnsArray.count; i++) {
        ECOTemplateListDetailCell *cell = [self.tableView viewAtColumn:i row:row makeIfNecessary:NO];
        cell.selectedMark = isSelected;
    }
}

#pragma mark - NSSearchFieldDelegate methods
- (void)controlTextDidChange:(NSNotification *)obj {
    self.selectedIndex = -1;
    [self refreshWithPackets:nil];
}
#pragma mark - getters
- (NSArray *)bizArray {
    if (!_bizArray) {
        _bizArray = [NSArray array];
    }
    return _bizArray;
}

@end
