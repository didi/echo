//
//  UIView+ECOViewBorder.h
//  EchoSDK
//
//  Created by zhanghe on 2019/8/28.
//

#import <Foundation/Foundation.h>

#define ECHOToggleViewBorderNotification    @"ECHOToggleViewBorderNotification"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ECOViewBorder)

@property (nonatomic, assign) CGColorRef previousBorderColor;
@property (nonatomic, assign) CGFloat previousBorderWidth;;


@end

NS_ASSUME_NONNULL_END
