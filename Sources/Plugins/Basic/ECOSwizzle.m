//
//  ECOSwizzle.m
//  Pods
//
//  Created by zhanghe on 2019/8/7.
//

#import "ECOSwizzle.h"
#import <objc/runtime.h>

@implementation ECOSwizzle

+ (void)swizzleInstanceMethodWithClass:(Class)class fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector {
    Method fromMethod = class_getInstanceMethod(class, fromSelector);
    Method toMethod = class_getInstanceMethod(class, toSelector);
    
    if (class_addMethod(class, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        class_replaceMethod(class, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
    } else {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}

+ (void)swizzleClassMethodWithClass:(Class)class fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector {
    Method fromMethod = class_getClassMethod(class, fromSelector);
    Method toMethod = class_getClassMethod(class, toSelector);
    class = object_getClass((id)class);
    
    if (class_addMethod(class, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        class_replaceMethod(class, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
    } else {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}

@end
