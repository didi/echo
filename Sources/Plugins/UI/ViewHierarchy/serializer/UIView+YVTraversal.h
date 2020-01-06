//
//  UIView+YVTraversal.h
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YVTraversalStepin.h"
#import "YVTraversalContext.h"
#import "UIView+YVNodeInfo.m"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YVTraversal)

-(NSDictionary*)traversal:(YVTraversalStepin*)stepIn context:(YVTraversalContext*)context;

@end

NS_ASSUME_NONNULL_END
