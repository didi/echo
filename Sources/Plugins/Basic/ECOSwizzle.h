//
//  ECOSwizzle.h
//  Pods
//
//  Created by zhanghe on 2019/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECOSwizzle : NSObject

+ (void)swizzleInstanceMethodWithClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector;
+ (void)swizzleClassMethodWithClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector;

@end

NS_ASSUME_NONNULL_END
