//
//  UIView+YVViewTree.m
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "UIView+YVViewTree.h"
#import "UIView+YVTraversal.h"
#import "YVTraversalStepin.h"
#import "YVTraversalContext.h"
#import "YVObjectManager.h"

@implementation UIView (YVViewTree)

+ (UIView*)_defaultRootView {
    return [UIApplication sharedApplication].keyWindow;
}

+ (NSString*)rootViewTreeString {
    NSData *viewtreedata = [NSJSONSerialization dataWithJSONObject:[self rootViewTreeDictionary] options:0 error:nil];
    return [[NSString alloc]initWithData:viewtreedata encoding:NSUTF8StringEncoding];
}

+ (NSDictionary*)rootViewTreeDictionary {
    YVTraversalStepin * stepIn = [[YVTraversalStepin alloc]init];
    YVTraversalContext * context = [[YVTraversalContext alloc]init];
    NSDictionary * viewtree = [[UIView _defaultRootView]traversal:stepIn context:context];
    NSDictionary * extraInfo = [context contextDict];
    [YVObjectManager sharedInstance].context = context;
    return @{
             @"viewtree":viewtree,
             @"extrainfo":extraInfo,
             };
}

@end
