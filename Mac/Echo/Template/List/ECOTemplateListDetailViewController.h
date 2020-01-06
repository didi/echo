//
//  ECOTemplateListDetailViewController.h
//  Echo
//
//  Created by 陈爱彬 on 2019/5/28. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>
#import "ECOPluginUIProtocol.h"

typedef BOOL(^ECOFilterBlock)(NSDictionary *item, NSString *filter);
typedef NSString *(^ECOColumnCellTitleBlock)(NSInteger columnIndex, NSDictionary *dict);
typedef NSString *(^ECODetailContentBlock)(NSDictionary *dict);

@interface ECOTemplateListDetailViewController : NSViewController
<ECOPluginUIProtocol>

@property (nonatomic, weak) __kindof ECOBasePlugin *plugin;

@property (weak) IBOutlet NSSplitView *splitView;
@property (nonatomic, copy) NSString *firstColumnTitle;
@property (nonatomic, copy) NSString *secondColumnTitle;

@property (nonatomic, strong) id templateData;

/**
 过滤内容处理block
 */
@property (nonatomic, copy) ECOFilterBlock filterBlock;

/**
 Cell标题处理block
 */
@property (nonatomic, copy) ECOColumnCellTitleBlock cellTitleBlock;

/**
 详情展示内容block
 */
@property (nonatomic, copy) ECODetailContentBlock contentBlock;

@end

