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

@end

NS_ASSUME_NONNULL_END
