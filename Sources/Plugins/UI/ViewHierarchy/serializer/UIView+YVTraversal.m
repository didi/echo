//
//  UIView+YVTraversal.m
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "UIView+YVTraversal.h"


@implementation UIView (YVTraversal)
-(NSDictionary*)traversal:(YVTraversalStepin*)stepIn context:(YVTraversalContext*)context
{
    [context updateFromView:self];
    YVTraversalStepin * stepined = [YVTraversalStepin stepInWithView:self parentInfo:stepIn];
    NSMutableDictionary * resDict = [NSMutableDictionary dictionary];
    NSMutableArray * children = [NSMutableArray array];
    for (UIView * each in self.subviews) {
        //只显示隐藏的视图
        [children addObject:[each traversal:stepined context:context]];
    }
    resDict[@"children"] = children.copy;
    [resDict addEntriesFromDictionary:[stepined stepinfo]];
    [resDict addEntriesFromDictionary:[self nodeInfo]];
    return resDict.copy;
}
@end
