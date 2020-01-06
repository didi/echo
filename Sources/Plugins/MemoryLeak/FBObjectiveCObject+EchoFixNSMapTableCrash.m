//
//  FBObjectiveCObject+EchoFixNSMapTableCrash.m
//  EchoSDK
//
//  Created by yxj on 2019/10/24.
//
// reference : https://github.com/facebook/FBRetainCycleDetector/pull/79/files
//             https://www.jianshu.com/p/ffe3bc954caf

#import "FBObjectiveCObject+EchoFixNSMapTableCrash.h"
#if __has_include(<RSSwizzle/RSSwizzle.h>)
#import <RSSwizzle/RSSwizzle.h>
#endif
#if __has_include(<FBRetainCycleDetector/FBRetainCycleDetector.h>)
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#endif

@implementation FBObjectiveCObject (EchoFixNSMapTableCrash)

+ (void)load {
#if __has_include(<FBRetainCycleDetector/FBRetainCycleDetector.h>)
#if __has_include(<RSSwizzle/RSSwizzle.h>)
    RSSwizzleInstanceMethod(FBObjectiveCObject, @selector(_objectRetainsEnumerableKeys) , BOOL, void, RSSWReplacement({
        /// addtional hook logic
        SEL objSel = NSSelectorFromString(@"object");
        id  object = [self performSelector:objSel];
        if ([object respondsToSelector:@selector(pointerFunctions)]) {
          NSPointerFunctions *pointerFunctions = [object pointerFunctions];
          if (pointerFunctions.acquireFunction == NULL) {
            return NO;
          }
        }
        BOOL result = RSSWCallOriginal();
        return result;
    }), 0, NULL)
#endif
#endif
}

@end
