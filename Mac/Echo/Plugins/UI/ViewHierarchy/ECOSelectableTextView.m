//
//  ECOSelectableTextView.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/19. Maintain by 陈爱彬
//  Description 
//

#import "ECOSelectableTextView.h"

@implementation ECOSelectableTextView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (NSView *)hitTest:(NSPoint)point
{
    return self.superview;
}

@end
