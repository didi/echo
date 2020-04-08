//
//  ECOTemplateOutlineViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/21. Maintain by 陈爱彬
//  Description 
//

#import "ECOTemplateOutlineViewController.h"
#import "ECOTemplateTableHeaderCell.h"
#import "ECOOlNodeFactory.h"
#import "ECOString.h"
#import "ECOTemplateOutlineCell.h"

#define COLUMN_ID_KEY   @"keyColumn"
#define COLUMN_ID_TYPE  @"typeColumn"
#define COLUMN_ID_VALUE @"valueColumn"

#define kNodeExpanded 1
#define kNodeColosed  0
#define kNodeCurrentStatus NSNotFound

#define AsyncMainBlock(block) dispatch_async(dispatch_get_main_queue(), ^{ block });

@interface ECOTemplateOutlineViewController () <
    NSOutlineViewDataSource,
    NSOutlineViewDelegate,
    NSSearchFieldDelegate
>
#pragma mark - ---| UI Parts |---
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSSearchField *searchBar;
#pragma mark - ---| Data Struct |---
@property (nonatomic) BOOL isSearching;
@property (nonatomic, copy) NSString *searcingKey;
@property (nonatomic, strong) NSArray *sortedKeys;
@property (nonatomic, strong) ECONodeDict *nodeInfos;
@property (nonatomic, strong) ECONodeDict *originNodeInfos;

@property (nonatomic, strong) ECOOlNode *selectedNode;
@property (nonatomic, strong) id latestPacket;
@end

@implementation ECOTemplateOutlineViewController

#pragma mark - ---| LifeCycle |---

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupBasicView];
}

#pragma mark - ---| ECOPluginUIProtocol |---

- (void)refreshWithPackets:(NSArray *)packets {
    id data = ((NSDictionary *)packets.lastObject)[@"data"];
    if (data == self.latestPacket) {
        return;
    }
    self.latestPacket = data;
    ///< 原始数据
    self.originNodeInfos = [ECOOlNodeFactory nodeInfosFromData:data];
    ///< 设置标题
    self.titleLabel.stringValue = self.plugin.name;
    ///< 搜索中不刷新
    if (!self.isSearching) {
        [self p_refresh];
    }
}

#pragma mark - ---| Setup & Reload & Update |---

- (void)p_setupBasicView {
    self.scrollView.wantsLayer = YES;
    self.scrollView.layer.cornerRadius = 15.f;
    self.scrollView.contentView.wantsLayer = YES;
    self.scrollView.contentView.layer.cornerRadius = 15.f;

    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"菜单"];
    [menu addItemWithTitle:@"删除" action:@selector(p_menuDelAction:) keyEquivalent:@""];
    self.outlineView.menu = menu;
    
    for (NSTableColumn *column in self.outlineView.tableColumns) {
        if ([column.identifier isEqualToString:COLUMN_ID_KEY]) {
            column.headerCell = [[ECOTemplateTableHeaderCell alloc] initTextCell:@"Key"];
        }else if ([column.identifier isEqualToString:COLUMN_ID_TYPE]) {
            column.headerCell = [[ECOTemplateTableHeaderCell alloc] initTextCell:@"Type"];
        }else if ([column.identifier isEqualToString:COLUMN_ID_VALUE]) {
            column.headerCell = [[ECOTemplateTableHeaderCell alloc] initTextCell:@"Value"];
        }
    }
}

- (void)p_refresh {
    self.isSearching = NO;
    self.searcingKey = nil;
    
    ECONodeDict *data = self.originNodeInfos.copy;
    AsyncMainBlock({
        [self p_reloadData:data];
        AsyncMainBlock({
            [self p_reloadExpandStatusBy:data status:kNodeColosed];
        })
    })
}

- (void)p_reloadData:(ECONodeDict *)data {
    self.nodeInfos = data;
    self.sortedKeys = [ECOOlNodeFactory sortKeysFromDictionary:self.nodeInfos];
    [self p_reload];
}

- (void)p_reload {
    [self.outlineView reloadData];
}

#pragma mark - ---| Action Handler |---

- (IBAction)onRefreshButtonClicked:(NSButton *)sender {
    [self p_refresh];
    [self p_sendData:[self p_cmdRefresh]];
}

- (void)p_menuDelAction:(NSMenuItem *)menuItem {
    NSInteger clickedRow = self.outlineView.clickedRow;
    id item = [self.outlineView itemAtRow:clickedRow];
    if (!item || ![item isKindOfClass:ECOOlNode.class]) {
        return;
    }
    ECOOlNode *node = (ECOOlNode *)item;
    
    NSString *title = [NSString stringWithFormat:@"你正在删除 NSUserDefault 中的数据!"];
    NSString *content = [NSString stringWithFormat:@"key : %@\nvalue : %@", node.key, node.value];
    [self showAlertWithTitle:title content:content buttonTitle:@"删除" completion:^{
        ///< Del value first.
        node.value = nil;

        ///< And update SDK with command.
        NSDictionary *cmd = nil;
        ECOOlNode *rootNode = [self p_updateTreeByNode:node];
        if (rootNode.value) {
            cmd = [self p_cmdSetByNode:rootNode];
        } else {
            cmd = [self p_cmdDelByNode:rootNode];
        }
        [self p_sendData:cmd];

        ///< Update local data.
        NSMutableDictionary *one = self.originNodeInfos.mutableCopy;
        if (rootNode.value) {
            one[rootNode.key] = rootNode;
        } else {
            [one removeObjectForKey:rootNode.key];
        }
        self.originNodeInfos = one.copy;
        
        ///< Reload UI.
        if ([self isSearching]) {
            [self p_startSearch];
        } else {
            [self p_reloadData:self.originNodeInfos.copy];
        }
    }];
}

#pragma mark - ---| NSOutlineViewDataSource |---

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    BOOL isRoot = item == nil;
    if ( isRoot ) {
        return self.nodeInfos.allKeys.count;
    }
    ECOOlNode *node = (ECOOlNode *)item;
    return node.subNodes.count;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    BOOL isRoot = item == nil;
    if ( isRoot ) {
        NSString *key = self.sortedKeys[index];
        ECOOlNode *rootNode = self.nodeInfos[key];
        return rootNode;
    } else {
        ECOOlNode *node = (ECOOlNode *)item;
        if (node.valueArray) {
            NSString *key = [ECOOlNodeFactory keyWithIndex:index];
            return node.subNodes[key];
        }
        if (node.valueDictionary) {
            NSArray *keysList = [node.subNodes.allKeys
                                 sortedArrayUsingComparator:^
                                 NSComparisonResult(NSString *obj1, NSString *obj2)
                                 {
                                     return obj1 < obj2;
                                 }];
            NSString *key = keysList[index];
            return node.subNodes[key];
        }
        return node;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    ECOOlNode *node = (ECOOlNode *)item;
    if (node.subNodes && node.subNodes.count > 0) {
        return YES;
    }
    return NO;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    ECOOlNode *node = (ECOOlNode *)item;
    NSString *key = node.key;
    BOOL isSelected = node == self.selectedNode;
    
    BOOL isKey = [tableColumn.identifier isEqualToString:COLUMN_ID_KEY];
    if ( isKey ) {
        ECOTemplateOutlineCell *keyCell = [outlineView makeViewWithIdentifier:@"keyCell" owner:self];
        NSAttributedString *one = [ECOString attributedWithValue:key
                                                   highlightText:self.searcingKey];
        keyCell.textField.attributedStringValue = one;
        keyCell.selectedMark = isSelected;
        return keyCell;
    }

    BOOL isType = [tableColumn.identifier isEqualToString:COLUMN_ID_TYPE];
    if ( isType ) {
        ECOTemplateOutlineCell *typeCell = [outlineView makeViewWithIdentifier:@"typeCell" owner:self];
        NSString *typeStr = [node valueTypeString];
        NSAttributedString *one = [ECOString attributedWithValue:typeStr
                                                   highlightText:self.searcingKey];
        typeCell.textField.attributedStringValue = one;
        typeCell.selectedMark = isSelected;
        return typeCell;
    }
    
    BOOL isValue = [tableColumn.identifier isEqualToString:COLUMN_ID_VALUE];
    if ( isValue ) {
        ECOTemplateOutlineCell *valueCell = [outlineView makeViewWithIdentifier:@"valueCell" owner:self];
        if (node.valueArray) {
            valueCell.textField.stringValue = [NSString stringWithFormat:@"(%@ item)", @(node.valueArray.count)];
        } else if (node.valueDictionary) {
            valueCell.textField.stringValue = [NSString stringWithFormat:@"(%@ pairs)", @(node.valueDictionary.allKeys.count)];
        } else {
            NSString *txt = [node nodeString];
            NSAttributedString *one = nil;
            if (txt) {
                one = [ECOString attributedWithValue:txt highlightText:self.searcingKey];
            } else {
                one = [ECOString attributedWithValue:@"ECO Err : Unknown Type" highlightText:self.searcingKey];
            }
            valueCell.textField.attributedStringValue = one;
        }
        valueCell.selectedMark = isSelected;
        return valueCell;
    }
    return nil;
}

#pragma mark - ---| NSOutlineViewDelegate |---
- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSInteger selectedRow = self.outlineView.selectedRow;
    ECOOlNode *node = (ECOOlNode *)[self.outlineView itemAtRow:selectedRow];
    self.selectedNode = node;
    [self.outlineView reloadData];
}

#pragma mark - ---| NSTextFieldDelegate |---

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
    if ([control isKindOfClass:NSSearchField.class]) {
        return YES;
    }
    NSTextField *textField = (NSTextField *)control;
    NSInteger rowIndex = [self.outlineView rowForView:textField];
    ECOOlNode *node = [self.outlineView itemAtRow:rowIndex];
    id value = node.value;
    BOOL editable = [self p_isSupportEditData:value];
    if ( editable ) {
        editable = node.isEditable;
    }
    return editable;
}

- (void)controlTextDidChange:(NSNotification *)obj {
    if ([obj.object isKindOfClass:NSSearchField.class]) {
        [self p_startSearch];
        return;
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    if ([obj.object isKindOfClass:NSSearchField.class]) {
        [self p_startSearch];
        return;
    }
    NSTextField *textField = obj.object;
    NSInteger rowIndex = [self.outlineView rowForView:textField];
    ECOOlNode *node = [self.outlineView itemAtRow:rowIndex];
    
    if (!node) {
//        NSCParameterAssert(node);
        return;
    }
    
    id value = node.value;
    BOOL editable = [self p_isSupportEditData:value];
    if (!editable ) {
        return;
    }
    
    NSString *input = textField.stringValue;
    id  result = [self p_transInput:input originValue:value];
    if (result == nil) {
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"你正在修改 NSUserDefault 中的数据!"];
    NSString *content = [NSString stringWithFormat:@"key : [%@]\nvalue : [%@] => [%@]", node.key, node.value, input];
    [self showAlertWithTitle:title content:content buttonTitle:@"修改" completion:^{
        node.value = result;
        ECOOlNode *one = [self p_updateTreeByNode:node];
        NSDictionary *cmd = [self p_cmdSetByNode:one];
        [self p_sendData:cmd];
        [self.outlineView reloadData];
    }];
}

- (void)p_removeNode:(ECOOlNode *)node parent:(ECOOlNode *)parentNode {
    NSMutableDictionary *subNodes = parentNode.subNodes.mutableCopy;
    [subNodes removeObjectForKey:node.key];
    parentNode.subNodes = subNodes.copy;
}

- (ECOOlNode *)p_updateTreeByNode:(ECOOlNode *)node {
    /*!
     更新与 node 相连的整片树，同时更新所有节点对应的数据结构
     */
    while (node.level > 0) {
        ECOOlNode *parentNode = node.parentNode;
        if (!parentNode) {
            return node;
        }
        if (parentNode.valueDictionary) {
            NSMutableDictionary *one = [parentNode.valueDictionary mutableCopy];
            BOOL isUpdate = node.value != nil;
            if ( isUpdate ) {
                [one setValue:node.value forKey:node.key];
            } else {
                [one removeObjectForKey:node.key];
                [parentNode removeSubNode:node];
            }
            parentNode.value = one.copy;
            goto end;
        }
        else if (parentNode.valueArray) {
            NSMutableArray *one = [parentNode.valueArray mutableCopy];
            NSInteger index = [ECOOlNodeFactory arrayIndexWithKey:node.key];
            if (index != NSNotFound && index < one.count) {
                BOOL isUpdate = node.value != nil;
                if ( isUpdate ) {
                    [one replaceObjectAtIndex:index withObject:node.value];
                } else {
                    [one removeObjectAtIndex:index];
                    [parentNode removeSubNode:node];
                }
                parentNode.value = one.copy;
                goto end;
            } else {
                NSCParameterAssert(nil);
            }
        } else {
            NSCParameterAssert(nil);
        }
    end:
        node = parentNode;
    }
    return node;
}

- (BOOL)p_isSupportEditData:(id)data {
    if (!data) {
        return NO;
    }
    
//    Class cls = [data class];
    BOOL isSupport = [self p_isSupportClass:data];
    return isSupport;
}

- (BOOL)p_isSupportClass:(id)data {
    if ([data isKindOfClass:NSString.class] ||
        [data isKindOfClass:NSNumber.class] ||
        [data isKindOfClass:NSData.class]   ||
        [data isKindOfClass:NSDate.class]) {
        return YES;
    }
    return NO;
}

- (id)p_transInput:(NSString *)input originValue:(id)value {
    if (!input || input.length == 0) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        if (![value isEqualToString:input]) {
            return input;
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *mNumber = [f numberFromString:input];
        if (mNumber != nil) {
            return mNumber;
        }
    }
    return nil;
}

- (void)showAlertWithTitle:(NSString *)title
                   content:(NSString *)content
               buttonTitle:(NSString *)btnTitle
                completion:(dispatch_block_t)completion
{
    NSAlert * alert = [[NSAlert alloc]init];
    [alert setMessageText:title];
    [alert setAlertStyle:NSAlertStyleInformational];
    [alert addButtonWithTitle:btnTitle];
    [alert addButtonWithTitle:@"取消"];
    [alert setInformativeText:content];
    [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
        if(returnCode == NSAlertFirstButtonReturn){
            !completion?:completion();
        }
    }];
}

#pragma mark - ---| NSSearchFieldDelegate |---

- (void)searchFieldDidStartSearching:(NSSearchField *)sender {
    self.isSearching = YES;
}

- (void)searchFieldDidEndSearching:(NSSearchField *)sender {
    self.isSearching = NO;
    [self p_refresh];
}

#pragma mark - ---| Search Access |---

- (void)p_startSearch {
    NSString *searchStr = self.searchBar.stringValue;
    self.searcingKey = searchStr;
    
    BOOL isBreak = searchStr.length <= 0;
    if ( isBreak ) {
        [self p_refresh];
        return;
    }
    
    ECONodeDict *one = [self p_filterNodesFrom:self.originNodeInfos with:searchStr];
    AsyncMainBlock({
        [self p_reloadData:one];
        AsyncMainBlock({
            [self p_reloadExpandStatusBy:one
                                  status:kNodeCurrentStatus];
        })
    })
}

- (ECONodeDict *)p_filterNodesFrom:(ECONodeDict *)nodes with:(NSString *)filterText {
    NSMutableDictionary <NodeType> *one = @{}.mutableCopy;
    [nodes enumerateKeysAndObjectsUsingBlock:^(NSString *key, ECOOlNode *obj, BOOL *stop) {
        BOOL found = [self p_isFoundNode:obj with:filterText];
        if ( found ) {
            [one setObject:obj forKey:key];
        }
    }];
    return one;
}

- (BOOL)p_isFoundNode:(ECOOlNode *)node with:(NSString *)filterText {
    BOOL hasSubNodes = node.subNodes && node.subNodes.count > 0;
    if ( hasSubNodes ) {
        __block BOOL found = NO;
        [node.subNodes enumerateKeysAndObjectsUsingBlock:^(NSString *key, ECOOlNode *obj, BOOL *stop) {
            if ([self p_isFoundNode:obj with:filterText]) found = YES;
        }];
        node.expand = found;
        if (found) return YES;
    }
    node.expand = NO;
    if ([self p_isMatchText:node.key byText:filterText] ||
        [self p_isMatchText:node.valueTypeString byText:filterText] ||
        [self p_isMatchText:node.nodeString byText:filterText]) {
        return YES;
    }
    return NO;
}

- (BOOL)p_isMatchText:(NSString *)text byText:(NSString *)searchText {
    if (text && text.length > 0 && searchText && searchText.length > 0) {
        NSString *a  = [text.copy lowercaseString];
        NSString *b  = [searchText.copy lowercaseString];
        BOOL isMatch = [a containsString:b];
        return isMatch;
    }
    return NO;
}

- (void)p_reloadExpandStatusBy:(ECONodeDict *)data status:(NSUInteger)status {
    if (!data || data.count == 0) return;
    [data enumerateKeysAndObjectsUsingBlock:^(NSString *key, ECOOlNode *obj, BOOL *stop) {
        [self p_reloadStatusWithNode:obj status:status];
    }];
}

- (void)p_reloadStatusWithNode:(ECOOlNode *)node status:(NSInteger)status {
    if (!node || ![node subNodes]) return;
    if ((status == kNodeCurrentStatus && !node.expand) ||
        (status == kNodeColosed)) {
        [self p_collapseNodeIfNeeded:node status:status];
    } else {
        [self p_expandNodeIfNeeded:node status:status];
    }
}

- (void)p_expandNodeIfNeeded:(ECOOlNode *)node status:(NSInteger)status {
    node.expand = YES;
    BOOL expandChildren = status == kNodeExpanded;
    [self.outlineView expandItem:node expandChildren:expandChildren];
    if (!expandChildren) {
        [self p_reloadExpandStatusBy:node.subNodes status:status];
    }
}

- (void)p_collapseNodeIfNeeded:(ECOOlNode *)node status:(NSInteger)status {
    node.expand = NO;
    BOOL collapseChildren = status == kNodeColosed;
    [self.outlineView collapseItem:node collapseChildren:collapseChildren];
    if (!collapseChildren) {
        [self p_reloadExpandStatusBy:node.subNodes status:status];
    }
}

#pragma mark - ---| CMD Access |---

- (NSDictionary *)p_cmdSetByNode:(ECOOlNode *)node {
    if (!node.key || !node.value) {
        NSCParameterAssert(nil);
        return nil;
    }
    NSDictionary *one = @{ @"cmd": @"set",
                           @"info": @{ @"key": node.key,
                                       @"value": node.value
                                       }
                           };
    return one;
}

- (NSDictionary *)p_cmdDelByNode:(ECOOlNode *)node {
    if (!node.key) {
        NSCParameterAssert(nil);
        return nil;
    }
    NSDictionary *one = @{ @"cmd": @"del",
                           @"info": @{ @"key": node.key }
                           };
    return one;
}

- (NSDictionary *)p_cmdRefresh {
    return @{@"cmd": @"refresh"};
}

- (void)p_sendData:(NSDictionary *)data {
    if (!data) {
        return;
    }
    NSLog(@"SendData:%@",data);
    !self.plugin.sendBlock ?:
     self.plugin.sendBlock(data);
}

@end
