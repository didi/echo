//
//  ECOUIString.h
//
//  Created by Lux on 2019/3/11.
//  Copyright © 2019 Lux. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ECOString : NSObject


+ (NSAttributedString *)attributedWithValue:(id)value
                              highlightText:(NSString *)highlightText;

+ (NSAttributedString *)attributedWithValue:(id)value
                              highlightText:(NSString *)highlightText
                             highlightColor:(NSColor *)color;

@end

