//
//  YVRightCellViewFrame.m
//  YourView
//
//  Created by bliss_ddo on 2019/5/6.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVRightCellViewClass.h"

@implementation YVRightCellViewClass

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)fillData:(NSDictionary*)data
{
    NSString *inherit = data[@"inherit"] ?: @"";
    self.clsInfoLabel.stringValue = inherit;
}

@end
