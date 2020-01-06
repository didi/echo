//
//  ECONetworkListTableCellView.h
//  Echo
//
//  Created by 陈爱彬 on 2019/9/29. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECONetworkListTableCellView : NSTableCellView

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL isCellSelected;

@end

NS_ASSUME_NONNULL_END
