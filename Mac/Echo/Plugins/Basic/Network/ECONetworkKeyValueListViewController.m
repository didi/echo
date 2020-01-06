//
//  ECONetworkKeyValueListViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/3. Maintain by 陈爱彬
//  Description 
//

#import "ECONetworkKeyValueListViewController.h"
#import "ECOTemplateTableHeaderCell.h"

@interface ECONetworkKeyValueListViewController ()
<NSTableViewDataSource,
NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@end

@implementation ECONetworkKeyValueListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupViews];
}
//设置视图效果
- (void)setupViews {
    //Header标题
    for (NSTableColumn *column in self.tableView.tableColumns) {
        if ([column.identifier isEqualToString:@"keyColumn"]) {
            column.headerCell = [[ECOTemplateTableHeaderCell alloc] initTextCell:@"Key"];
        }else if ([column.identifier isEqualToString:@"valueColumn"]) {
            column.headerCell = [[ECOTemplateTableHeaderCell alloc] initTextCell:@"Value"];
        }
    }
}
- (void)setParamsList:(NSArray *)paramsList {
    _paramsList = paramsList;
    //刷新UI
    [self.tableView reloadData];
}
#pragma mark - NSTableViewDataSource methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.paramsList.count;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSDictionary *item = self.paramsList[row];
    if ([tableColumn.identifier isEqualToString:@"keyColumn"]) {
        NSTableCellView *cell = [tableView makeViewWithIdentifier:@"keyCell" owner:nil];
        cell.textField.stringValue = item[@"key"] ?: @"";
        return cell;
    }else if ([tableColumn.identifier isEqualToString:@"valueColumn"]) {
        NSTableCellView *cell = [tableView makeViewWithIdentifier:@"valueCell" owner:nil];
        cell.textField.stringValue = item[@"value"] ?: @"";
        return cell;
    }
    return nil;
}
#pragma mark - NSTableViewDelegate methods
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
//    NSInteger selectedRow = self.tableView.selectedRow;
//    NSDictionary *contentDict = nil;
//    if (selectedRow != -1) {
//        contentDict = self.paramsList[selectedRow];
//    }
}
@end
