//
//  YVRightCellBase.m
//  YourView
//
//  Created by bliss_ddo on 2019/5/6.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVRightCellBase.h"

@implementation YVRightCellBase

-(void)awakeFromNib
{
    self.layer.backgroundColor = [NSColor clearColor].CGColor;
}

+(NSView*)makeView:(NSTableView*)tableView owner:(id)owner identifer:(NSString*)identifer 
{
    YVRightCellBase * t = [tableView makeViewWithIdentifier:identifer owner:owner];
    if (t == nil) {
        NSArray * bundleviews;
        [[NSBundle mainBundle]loadNibNamed:identifer owner:owner topLevelObjects:&bundleviews];
        for (id object in bundleviews) {
            if ([object isKindOfClass:[NSView class]]) {
                t = object;
                break;
            }
        }
    }
    return t;
}

-(void)fillData:(id)data
{
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
