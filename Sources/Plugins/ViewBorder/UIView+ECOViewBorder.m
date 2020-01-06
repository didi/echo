//
//  UIView+ECOViewBorder.m
//  EchoSDK
//
//  Created by zhanghe on 2019/8/28.
//

#import "UIView+ECOViewBorder.h"
#import "ECOViewBorderInspector.h"
#import "ECOSwizzle.h"
#import <objc/runtime.h>

@implementation UIView (ECOViewBorder)

static NSString *UIView_ECOViewBorderLayer = @"UIView_ECOViewBorderLayer";

+ (void)load {
    [ECOSwizzle swizzleInstanceMethodWithClass:[UIView class] fromSelector:@selector(initWithFrame:) toSelector:@selector(eco_initWithFrame:)];
    [ECOSwizzle swizzleInstanceMethodWithClass:[UIView class] fromSelector:@selector(initWithCoder:) toSelector:@selector(eco_initWithCoder:)];
    [ECOSwizzle swizzleInstanceMethodWithClass:[UIView class] fromSelector:NSSelectorFromString(@"dealloc") toSelector:@selector(eco_dealloc)];
}

- (id)eco_initWithFrame:(CGRect)frame {
    UIView *view = [self eco_initWithFrame:frame];
    [view eco_onToggleViewBorder];
    [[NSNotificationCenter defaultCenter] addObserver:view selector:@selector(eco_onToggleViewBorder) name:ECHOToggleViewBorderNotification object:nil];
    return view;
}

- (id)eco_initWithCoder:(NSCoder *)coder {
    UIView *view = [self eco_initWithCoder:coder];
    [view eco_onToggleViewBorder];
    [[NSNotificationCenter defaultCenter] addObserver:view selector:@selector(eco_onToggleViewBorder) name:ECHOToggleViewBorderNotification object:nil];
    return view;
}

- (void)eco_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ECHOToggleViewBorderNotification object:nil];
    [self eco_dealloc];
}

- (void)eco_onToggleViewBorder {
    BOOL show = [[ECOViewBorderInspector sharedInstance] showViewBorder];
    if (show) {
        self.previousBorderColor = self.layer.borderColor;
        self.previousBorderWidth = self.layer.borderWidth;
        self.layer.borderColor = [[UIColor redColor] CGColor];
        self.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    } else {
        self.layer.borderColor = self.previousBorderColor;
        self.layer.borderWidth = self.previousBorderWidth;
    }
}

- (void)setPreviousBorderColor:(CGColorRef)previousBorderColor {
    UIColor *color = [UIColor colorWithCGColor:previousBorderColor];
    objc_setAssociatedObject(self, @selector(previousBorderColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGColorRef)previousBorderColor {
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    return [color CGColor];
}

- (void)setPreviousBorderWidth:(CGFloat)previousBorderWidth {
    NSNumber *width = @(previousBorderWidth);
    objc_setAssociatedObject(self, @selector(previousBorderWidth), width, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)previousBorderWidth {
    NSNumber *width = objc_getAssociatedObject(self, _cmd);
    return width.floatValue;
}

@end
