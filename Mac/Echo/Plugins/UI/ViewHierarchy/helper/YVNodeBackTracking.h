//
//  YVNodeBackTracking.h
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVNodeBackTracking : NSObject
+(NSInteger)findBestZFromlevelDict:(NSMutableDictionary*)levelDict minDepth:(NSInteger)minDeepth maxDepth:(NSInteger)maxDeepth frame:(CGRect)crect;
@end

NS_ASSUME_NONNULL_END
