//
//  YVTraversalStepin.h
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVTraversalStepin : NSObject
+(YVTraversalStepin*)stepInWithView:(UIView*)b parentInfo:(YVTraversalStepin*)parent;
-(NSDictionary*)stepinfo;
@end

NS_ASSUME_NONNULL_END
