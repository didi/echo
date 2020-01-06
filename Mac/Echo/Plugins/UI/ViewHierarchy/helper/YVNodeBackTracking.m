//
//  YVNodeBackTracking.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVNodeBackTracking.h"
#import "YVCGRectHelper.h"

@implementation YVNodeBackTracking
+(NSInteger)findBestZFromlevelDict:(NSMutableDictionary*)levelDict minDepth:(NSInteger)minDeepth maxDepth:(NSInteger)maxDeepth frame:(CGRect)crect
{
    CGRect crect_expand = [YVCGRectHelper CGRectExpand:crect];
    NSInteger bestZ = 0;
    while (YES) {
        if (maxDeepth < 0 || maxDeepth < minDeepth) {
            break;
        }
        NSMutableArray * levelArray = levelDict[@(maxDeepth)];
        if (levelArray == nil) {
            bestZ = maxDeepth--;
        }else{
            BOOL hit = NO;
            for (NSValue * eachValue in levelArray) {
                CGRect eachFrame;
                [eachValue getValue:&eachFrame size:sizeof(CGRect)];
                if (CGRectIntersectsRect(crect_expand, eachFrame)) {
                    hit = YES;
                    break;
                }
            }
            if (hit) {
                break;
            }
            bestZ = maxDeepth--;
        }
    }
    NSMutableArray * levelArray = levelDict[@(bestZ)];
    if (!levelArray) {
        levelArray = [NSMutableArray array];
        levelDict[@(bestZ)] = levelArray;
    }
    [levelArray addObject:[NSValue valueWithRect:crect]];
    return bestZ;
}
@end
