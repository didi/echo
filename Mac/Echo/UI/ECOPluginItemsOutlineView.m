//
//  ECOPluginItemsOutlineView.m
//  Echo
//
//  Created by 陈爱彬 on 2019/11/4. Maintain by 陈爱彬
//  Description 
//

#import "ECOPluginItemsOutlineView.h"

@implementation ECOPluginItemsOutlineView

- (NSMenu *)menuForEvent:(NSEvent *)event {
    NSPoint pt = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:pt];
    if (row < 0 || [event type] != NSEventTypeRightMouseDown) {
        return [super menuForEvent:event];
    }
    self.menuRow = row;
    return self.menu;
}

@end
