//
//  ECOTemplateTableHeaderCell.m
//  Echo
//
//  Created by 陈爱彬 on 2019/5/23. Maintain by 陈爱彬
//  Description 
//

#import "ECOTemplateTableHeaderCell.h"

@interface ECOTemplateTableHeaderCell()

@end

@implementation ECOTemplateTableHeaderCell


- (instancetype)initTextCell:(NSString *)string {
    self = [super initTextCell:string];
    if (self) {
        
    }
    return self;
}
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    [self drawInteriorWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSColor *fillColor = [NSColor colorNamed:@"listDetail_header"];
    NSColor *titleColor = [NSColor colorNamed:@"listDetail_headerTitle"];
    [fillColor setFill];
    NSRectFill(cellFrame);
    NSRange range = NSMakeRange(0, self.stringValue.length);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.stringValue];
    [attributedString addAttribute:NSForegroundColorAttributeName value:titleColor range:range];
    [attributedString addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:13] range:range];
    self.attributedStringValue = attributedString;
    
    [super drawInteriorWithFrame:NSMakeRect(cellFrame.origin.x + 5, cellFrame.origin.y + 4, cellFrame.size.width, cellFrame.size.height) inView:controlView];
}
- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    [self drawInteriorWithFrame:cellFrame inView:controlView];
}
@end
