//
//  YVRightCellViewFrame.m
//  YourView
//
//  Created by bliss_ddo on 2019/5/6.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVRightCellViewFrame.h"

@interface YVRightCellViewFrame()

@property (nonatomic, copy) NSDictionary *viewData;
@end

@implementation YVRightCellViewFrame

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


-(void)fillData:(NSDictionary*)data {
    self.viewData = data;
    NSString *frameStr = data[@"localframe"];
    CGRect frame = NSRectFromString(frameStr);
    self.frameX.floatValue = frame.origin.x;
    self.frameY.floatValue = frame.origin.y;
    self.frameW.floatValue = frame.size.width;
    self.frameH.floatValue = frame.size.height;
}

- (IBAction)onFrameXChanged:(NSTextField *)sender {
    [self sendFrameChangedInfo];
}

- (IBAction)onFrameYChanged:(NSTextField *)sender {
    [self sendFrameChangedInfo];
}

- (IBAction)onFrameWChanged:(NSTextField *)sender {
    [self sendFrameChangedInfo];
}

- (IBAction)onFrameHChanged:(NSTextField *)sender {
    [self sendFrameChangedInfo];
}

- (void)sendFrameChangedInfo {
    CGRect rect = NSMakeRect(self.frameX.floatValue, self.frameY.floatValue, self.frameW.floatValue, self.frameH.floatValue);
    NSString *frameStr = NSStringFromRect(rect);
    NSDictionary *info = @{
                           @"cmd": @"edit",
                           @"address": self.viewData[@"address"] ?: @"",
                           @"sel": @"localframe",
                           @"argv": frameStr
                           };
    !self.editBlock ?: self.editBlock(info);
}

@end
