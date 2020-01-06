//
//  YVRightCellViewInfo.h
//  YourView
//
//  Created by bliss_ddo on 2019/5/6.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YVRightCellBase.h"
NS_ASSUME_NONNULL_BEGIN

@interface YVRightCellViewInfo : YVRightCellBase

@property (weak) IBOutlet NSButton *hiddenBtn;
@property (weak) IBOutlet NSButton *userInteractionBtn;
@property (weak) IBOutlet NSButton *masksTBBtn;
@property (weak) IBOutlet NSTextField *alphaTextField;
@property (weak) IBOutlet NSPopUpButton *bgColorPopupBtn;
@property (weak) IBOutlet NSPopUpButton *borderPopupBtn;
@property (weak) IBOutlet NSTextField *borderWidthTextField;
@property (weak) IBOutlet NSTextField *radiusTextField;
@property (weak) IBOutlet NSPopUpButton *shadowPopupBtn;
@property (weak) IBOutlet NSTextField *shadowOpaTextField;
@property (weak) IBOutlet NSTextField *shadowRadiusTextField;
@property (weak) IBOutlet NSTextField *shadowOffsetWTextField;
@property (weak) IBOutlet NSTextField *shadowOffsetHTextField;


@end

NS_ASSUME_NONNULL_END
