//
//  ECOPluginTableCellView.h
//  Echo
//
//  Created by 陈爱彬 on 2019/4/30. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>

@interface ECOPluginTableCellView : NSTableCellView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *appIcon;
@property (nonatomic, copy) NSString *pluginDefaultIcon;
@property (nonatomic, copy) NSString *pluginSelectedIcon;
@property (nonatomic, assign) BOOL rootNode;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL showTriangle;

- (void)refreshView;

@end
