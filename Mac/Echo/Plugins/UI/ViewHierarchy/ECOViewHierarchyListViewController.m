//
//  ECOViewHierarchyListViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/19. Maintain by 陈爱彬
//  Description 
//

#import "ECOViewHierarchyListViewController.h"
#import "ECOSelectableTextView.h"
#import <Masonry/Masonry.h>

@interface ECOViewHierarchyListViewController ()
<NSOutlineViewDataSource,
NSOutlineViewDelegate>

@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSSearchField *searchField;
@property (nonatomic, strong) NSDictionary *dataSource;
@property (nonatomic) NSString *searchString;
@property (nonatomic, strong) NSMutableDictionary *editInfos;

@end

@implementation ECOViewHierarchyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.outlineView.enclosingScrollView.hasHorizontalScroller = YES;
}
//刷新列表侧
- (void)refreshViewTreeListWithData:(NSDictionary *)dict {
    self.dataSource = dict[@"viewtree"];
    [self.outlineView reloadData];
    [self.outlineView expandItem:nil expandChildren:YES];
}
//视图场景的选中节点变更了
- (void)sceneNodeSelected:(NSDictionary *)nodeInfo {
    if (nodeInfo) {
        NSInteger sindex = [self.outlineView rowForItem:nodeInfo];
//        NSInteger sindex = index.integerValue;
        [self.outlineView expandItem:nil expandChildren:YES];
        [self.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:sindex] byExtendingSelection:false];
        [self.outlineView scrollRowToVisible:sindex];
        //回调给外部选中信息
        NSString *uuid = nodeInfo[@"address"];
        NSDictionary *editNode = [self.editInfos objectForKey:uuid];
        if (editNode) {
            //该信息已被编辑过，更新数据
            NSMutableDictionary *updateItem = [NSMutableDictionary dictionaryWithDictionary:nodeInfo];
            [updateItem addEntriesFromDictionary:editNode];
            nodeInfo = updateItem.copy;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(listNodeDidSelectedWithInfo:)]) {
//            NSDictionary *info = [self.outlineView itemAtRow:sindex];
            [self.delegate listNodeDidSelectedWithInfo:nodeInfo];
        }
    }else{
        //        [self.outlineView selectRowIndexes: nil byExtendingSelection:false];
    }
}
//更新编辑后的信息
- (void)updateEditInfo:(NSDictionary *)extraInfo {
    [self.editInfos addEntriesFromDictionary:extraInfo];
}
#pragma mark - NSOutlineViewDataSource methods
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    NSDictionary *ds = (NSDictionary *)item;
    if (ds == nil) {
        return 1;
    }
    NSArray *arr = ds[@"children"];
    return arr.count;
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    NSDictionary *ds = (NSDictionary *)item;
    if (ds == nil) {
        return self.dataSource;
    }
    NSArray *arr = ds[@"children"];
    return arr[index];
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    NSDictionary *ds = (NSDictionary *)item;
    if (ds == nil) {
        return YES;
    }
    NSArray *arr = ds[@"children"];
    return arr.count > 0;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item {
    return YES;
}
- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    return 18;
}
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    if (item == nil) {
        return self.dataSource[@"class"];
    }
    NSString * type = ((NSDictionary*)item)[@"class"] ?: @"";
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:type];
    [attrStr setAttributes:@{NSFontAttributeName:[NSFont systemFontOfSize:12]} range:NSMakeRange(0, type.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[NSColor colorNamed:@"viewList_text_color"] range:NSMakeRange(0, type.length)];
    
    if (self.searchString) {
        NSRange searchRange = [type.lowercaseString rangeOfString:self.searchString.lowercaseString];
        if (searchRange.location != NSNotFound) {
            [attrStr addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:searchRange];
            [attrStr addAttribute:NSBackgroundColorAttributeName value:[NSColor yellowColor] range:searchRange];
        }
    }
    
    [attrStr insertAttributedString:[[NSMutableAttributedString alloc]initWithString:@" "] atIndex:0];
    
    //    NSString *imageName = @"left_blue.png";
    NSString *imageName = @"cellimage_view@2x.png";
    NSImage * img = [NSImage imageNamed:imageName];
    NSData * imgData = [img TIFFRepresentationUsingCompression:6 factor:0.5];
    
    NSFileWrapper *imageFileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:imgData];
    imageFileWrapper.filename = imageName;
    imageFileWrapper.preferredFilename = imageName;
    
    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] initWithFileWrapper:imageFileWrapper];
    //    imageAttachment.bounds = CGRectMake(0, -paddingTop, font.lineHeight, font.lineHeight);
    //    CGFloat paddingTop = displayFont.lineHeight - displayFont.pointSize;
    
    imageAttachment.bounds = CGRectMake(0, -20, 10, 10);
    
    NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    [attrStr insertAttributedString:imageAttributedString atIndex:0];
    
    
    return attrStr;
}
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    ECOSelectableTextView *cellView = [outlineView makeViewWithIdentifier:@"cellView" owner:nil];
    if (cellView == nil) {
        cellView = [[ECOSelectableTextView alloc] init];
        cellView.identifier = @"cellView";
        cellView.editable = NO;
        cellView.textContainer.widthTracksTextView = NO;
        cellView.textContainer.containerSize = CGSizeMake(10000, 10000);
        cellView.backgroundColor = [NSColor clearColor];
    }
    
    NSAttributedString * attrStr = [self outlineView:outlineView objectValueForTableColumn:tableColumn byItem:item];
    [cellView.textStorage setAttributedString:attrStr];
    return cellView;
}
#pragma mark - NSOutlineViewDelegate methods
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
//    NSDictionary *selectedItem = (NSDictionary *)item;
//    BOOL isHidden = [selectedItem[@"isHidden"] boolValue];
//    CGFloat alpha = [selectedItem[@"alpha"] floatValue];
//    if (isHidden || alpha == 0) {
//        return NO;
//    }
    return YES;
}
- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSInteger selectedRow = self.outlineView.selectedRow;
    NSDictionary *selectedItem = [self.outlineView itemAtRow:selectedRow];
//    NSString *uuid = selectedItem[@"view_level"];
    NSString *uuid = selectedItem[@"address"];
    NSDictionary *editNode = [self.editInfos objectForKey:uuid];
    if (editNode) {
        //该信息已被编辑过，更新数据
        NSMutableDictionary *updateItem = [NSMutableDictionary dictionaryWithDictionary:selectedItem];
        [updateItem addEntriesFromDictionary:editNode];
        selectedItem = updateItem.copy;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(listNodeDidSelectedWithInfo:)]) {
        [self.delegate listNodeDidSelectedWithInfo:selectedItem];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(listNodeDidSelectedWithViewUUID:)]) {
        [self.delegate listNodeDidSelectedWithViewUUID:uuid];
    }
}
#pragma mark - NSSearchFieldDelegate methods
- (void)controlTextDidChange:(NSNotification *)obj {
    self.searchString = self.searchField.stringValue;
    [self.outlineView expandItem:nil expandChildren:YES];
    [self.outlineView reloadData];
}
#pragma mark - getters
- (NSMutableDictionary *)editInfos {
    if (!_editInfos) {
        _editInfos = [NSMutableDictionary dictionary];
    }
    return _editInfos;
}
@end
