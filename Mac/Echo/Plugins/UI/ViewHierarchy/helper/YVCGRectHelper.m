//
//  YVCGRectHelper.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVCGRectHelper.h"
#import "defines.h"

@implementation YVCGRectHelper
+(CGRect)CGRectExpand:(CGRect)rect
{
    return [self CGRectExpand:rect threashold:YVRectDefaultExpandThreshold];
}

+(CGRect)CGRectExpand:(CGRect)rect threashold:(CGFloat)threshold
{
    CGFloat x = rect.origin.x - threshold / 2;
    CGFloat y = rect.origin.y - threshold / 2;
    CGFloat w = rect.size.width + threshold;
    CGFloat h = rect.size.height + threshold;
    return CGRectMake(x, y, w, h);
}

+(CGRect)UIKitRectTransformToSceneRect:(CGRect)UIKitRect withScreenSize:(CGSize)screenSize;
{
    CGFloat x = UIKitRect.origin.x;
    CGFloat y = UIKitRect.origin.y;
    CGFloat w = UIKitRect.size.width;
    CGFloat h = UIKitRect.size.height;
    CGFloat xOffSet = -screenSize.width / 2;
    CGFloat yOffSet = screenSize.height / 2;
    CGFloat x_transformed = (x + w / 2 + xOffSet) ;
    CGFloat y_transformed = (-(y + h / 2) + yOffSet) ;
    return CGRectMake(x_transformed, y_transformed, w, h);
}

@end
