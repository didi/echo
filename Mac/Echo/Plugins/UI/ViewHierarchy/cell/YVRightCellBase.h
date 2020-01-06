//
//  YVRightCellBase.h
//  YourView
//
//  Created by bliss_ddo on 2019/5/6.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^ECOViewInfoEditBlock)(NSDictionary *info);

NS_ASSUME_NONNULL_BEGIN

@interface YVRightCellBase : NSView

@property (nonatomic, copy) ECOViewInfoEditBlock editBlock;

+(instancetype)makeView:(NSTableView*)tableView owner:(id)owner identifer:(NSString*)identifer;

-(void)fillData:(id)data;

@end

NS_ASSUME_NONNULL_END
