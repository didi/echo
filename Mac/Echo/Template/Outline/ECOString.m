//
//  ECOUIString.m
//
//  Created by Lux on 2019/3/11.
//  Copyright © 2019 Lux. All rights reserved.
//

#import "ECOString.h"

@implementation ECOString

+ (NSAttributedString *)attributedWithValue:(id)value
                              highlightText:(NSString *)highlightText
{
    return [self attributedWithValue:value
                       highlightText:highlightText
                      highlightColor:nil];
}

+ (NSAttributedString *)attributedWithValue:(id)value
                             highlightText:(NSString *)highlightText
                            highlightColor:(NSColor *)color
{
    NSString *text = value;
    if (value && ![value isKindOfClass:NSString.class]) {
        text = [value stringValue];
    }
    
    if (text == nil && highlightText == nil) return nil;
    if (text == nil && highlightText != nil) {
        text = highlightText;
    }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    if (attStr.length == 0) {
        return attStr;
    }
    
    if (highlightText) {
        NSRange range = [text rangeOfString:highlightText options:NSCaseInsensitiveSearch];
        if (range.length >= 0 && range.location < text.length) {
            NSFont *font = [NSFont boldSystemFontOfSize:[NSFont systemFontSize]];
            [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
            
            font = [NSFont boldSystemFontOfSize:[NSFont systemFontSize]];
            [attStr addAttribute:NSFontAttributeName value:font range:range];
            
            NSColor *lcolor = color ?: [NSColor colorWithRed:1 green:0.1 blue:0.1 alpha:0.9];
            [attStr addAttribute:NSForegroundColorAttributeName value:lcolor range:range];
        }
    }
    
    return attStr;
}

@end
