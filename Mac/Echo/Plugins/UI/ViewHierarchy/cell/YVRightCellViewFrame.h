//
//  YVRightCellViewFrame.h
//  YourView
//
//  Created by bliss_ddo on 2019/5/6.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVRightCellBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface YVRightCellViewFrame : YVRightCellBase

@property (weak) IBOutlet NSTextField *frameX;
@property (weak) IBOutlet NSTextField *frameY;
@property (weak) IBOutlet NSTextField *frameW;
@property (weak) IBOutlet NSTextField *frameH;

@end

NS_ASSUME_NONNULL_END
