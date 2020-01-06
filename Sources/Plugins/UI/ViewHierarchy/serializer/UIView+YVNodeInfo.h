//
//  UIView+YVNodeInfo.h
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+YVNodeInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YVNodeInfo)
- (NSDictionary*)nodeInfo;

- (NSDictionary *)ecoUpdateInfo;

- (NSString *)_ecoColorRGBA:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
