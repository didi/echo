//
//  UIView+YVNodeInfo.m
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "UIView+YVNodeInfo.h"
#import "NSObject+YVNodeInfo.h"

@implementation UIView (YVNodeInfo)

-(NSDictionary*)nodeInfo
{
    NSString *_snapshot = [self _snapWithSublayer:NO];
    NSString *_localframe = [self _localframe];
    NSString *_windowframe = [self _windowFrame];
    NSNumber *_isHidden = @(self.isHidden);
    NSNumber *_alphaValue = @(self.alpha);
    NSNumber *_userInteraction = [self _ecoViewUserInteractionEnabled];
    NSNumber *_masksToBounds = [self _ecoMasksToBoundsFlag];
    NSString *_bgColor = [self _ecoBgColor];
    NSString *_borderColor = [self _ecoBorderColor];
    NSNumber *_borderWidth = [self _ecoBorderWidth];
    NSNumber *_cornerRadius = [self _ecoCornerRadius];
    NSString *_shadowColor = [self _ecoShadowColor];
    NSNumber *_shadowOpacity = [self _ecoShadowOpacity];
    NSNumber *_shadowRadius = [self _ecoShadowRadius];
    NSNumber *_shadowOffsetW = [self _ecoShadowOffsetW];
    NSNumber *_shadowOffsetH = [self _ecoShadowOffsetH];
    
    NSDictionary * selfinfo = @{
             @"snapshot":_snapshot,
             @"localframe":_localframe,
             @"windowframe":_windowframe,
             @"isHidden": _isHidden,
             @"alpha": _alphaValue,
             @"userInter": _userInteraction,
             @"masksTB": _masksToBounds,
             @"bgColor": _bgColor,
             @"bdColor": _borderColor,
             @"bdWidth": _borderWidth,
             @"radius": _cornerRadius,
             @"sColor": _shadowColor,
             @"sOpacity": _shadowOpacity,
             @"sRadius": _shadowRadius,
             @"sOffW": _shadowOffsetW,
             @"sOffH": _shadowOffsetH
             };
    NSDictionary * superinfo = [super nodeInfo];
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    [result addEntriesFromDictionary:selfinfo];
    [result addEntriesFromDictionary:superinfo];
    return result.copy;
}

- (NSDictionary *)ecoUpdateInfo {
    BOOL hasShot = NO;
    if (!self.isHidden && self.alpha != 0) {
        hasShot = YES;
    }
    return [self ecoUpdateInfoWithRootShot:hasShot];
}

- (NSDictionary *)ecoUpdateInfoWithRootShot:(BOOL)hasRootShot {
    NSString *_address = [self ecoNodeAddress];
    NSString *_snapshot = @"";
    if (!self.isHidden && self.alpha != 0 && hasRootShot) {
        _snapshot = [self _snapWithSublayer:NO];
    }
    
    NSMutableDictionary *nodesInfo = [NSMutableDictionary dictionary];
    NSDictionary * selfinfo = @{
                               @"snapshot":_snapshot,
                               @"address":_address
                               };
    [nodesInfo setObject:selfinfo forKey:_address];
    
    for (UIView * each in self.subviews) {
        //只显示隐藏的视图
        [nodesInfo addEntriesFromDictionary:[each ecoUpdateInfoWithRootShot:hasRootShot]];
    }
    
    return nodesInfo.copy;
}

-(NSString*)_windowFrame
{
    CGRect windowRect = [UIScreen mainScreen].bounds;
    windowRect = [self convertRect:self.bounds toView:nil];
    return NSStringFromCGRect(windowRect);
}

-(NSString*)_localframe
{
    return NSStringFromCGRect(self.frame);
}


-(NSString*)_snapWithSublayer:(BOOL)containSublayer
{
    if (self.frame.size.width == 0 ||
        self.frame.size.height == 0) {
        return @"";
    }
    NSMutableArray * restoreArray = [NSMutableArray array];
    if (!containSublayer) {
        for (CALayer*ly in self.layer.sublayers) {
            if (!ly.hidden && ![ly isKindOfClass:NSClassFromString(@"_UILabelContentLayer")]) {
                ly.hidden = YES;
                [restoreArray addObject:ly];
            }
        }
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData * imageData = UIImagePNGRepresentation(snapshot);
    NSString * imageStringBase64 = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    if (!containSublayer) {
        for (CALayer*ly in restoreArray) {
            ly.hidden = NO;
        }
    }
    if (imageStringBase64 == nil) {
        NSLog(@"view snap shot is nil");
        NSLog(@"[❌%@]",self);
    }
    return imageStringBase64==nil ?@"":imageStringBase64;
}

- (NSNumber *)_ecoViewUserInteractionEnabled {
    return @(self.userInteractionEnabled);
}

- (NSNumber *)_ecoMasksToBoundsFlag {
    return @(self.layer.masksToBounds);
}

- (NSString *)_ecoColorRGBA:(UIColor *)color {
    CGFloat R, G, B, A;
    if (color == nil ||
        color == [UIColor clearColor]) {
        return @"";
    }
    BOOL result = [color getRed:&R green:&G blue:&B alpha:&A];
    if (result) {
        NSNumber *rColor = @((NSInteger)((R*255)));
        NSNumber *gColor = @((NSInteger)((G*255)));
        NSNumber *bColor = @((NSInteger)((B*255)));
        NSString *alpha = [self _ecoDisplayColorFrom:A];
        return [NSString stringWithFormat:@"%@,%@,%@,%@", rColor, gColor, bColor, alpha];
    }
    return @"";
}

- (NSString *)_ecoDisplayColorFrom:(CGFloat)c {
    NSString *str = @"";
    if (fmodf(c*10, 1) > 0) {
        //最多保留小数点两位
        str = [NSString stringWithFormat:@"%.2f", c];
    }else{
        //保留完整数据
        str = [NSString stringWithFormat:@"%@", @(c)];
    }
    return str;
}

- (NSString *)_ecoBgColor {
    UIColor *bgColor = self.backgroundColor;
    return [self _ecoColorRGBA:bgColor];
}


- (NSString *)_ecoBorderColor {
    UIColor *borderColor = [UIColor colorWithCGColor:self.layer.borderColor];
    return [self _ecoColorRGBA:borderColor];
}

- (NSNumber *)_ecoBorderWidth {
    return @(self.layer.borderWidth);
}

- (NSNumber *)_ecoCornerRadius {
    return @(self.layer.cornerRadius);
}

- (NSString *)_ecoShadowColor {
    UIColor *shadowColor = [UIColor colorWithCGColor:self.layer.shadowColor];
    return [self _ecoColorRGBA:shadowColor];
}

- (NSNumber *)_ecoShadowOpacity {
    return @(self.layer.shadowOpacity);
}

- (NSNumber *)_ecoShadowRadius {
    return @(self.layer.shadowRadius);
}

- (NSNumber *)_ecoShadowOffsetW {
    return @(self.layer.shadowOffset.width);
}

- (NSNumber *)_ecoShadowOffsetH {
    return @(self.layer.shadowOffset.height);
}
@end
