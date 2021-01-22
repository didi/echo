//
//  ECOTemplateListDetailCell.h
//  Echo
//
//  Created by 陈爱彬 on 2019/8/15. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECOTemplateListDetailCell : NSTableCellView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL selectedMark;

/// 控制 title 文字的裁切
@property (nonatomic) NSLineBreakMode titleLineBreak;

@end

NS_ASSUME_NONNULL_END
