//
//  YVCGRectHelper.h
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVCGRectHelper : NSObject
+(CGRect)CGRectExpand:(CGRect)rect;
+(CGRect)UIKitRectTransformToSceneRect:(CGRect)UIKitRect withScreenSize:(CGSize)screenSize;
@end

NS_ASSUME_NONNULL_END
