//
//  NSURLSessionConfiguration+ECHO.m
//  EchoSDK
//
//  Created by zhanghe on 2019/8/7.
//

#import "NSURLSessionConfiguration+ECHO.h"
#import "ECOSwizzle.h"
#import "ECONSURLProtocol.h"

@implementation NSURLSessionConfiguration (ECHO)

+ (void)load {
    [ECOSwizzle swizzleClassMethodWithClass:[self class] fromSelector:@selector(defaultSessionConfiguration) toSelector:@selector(echo_defaultSessionConfiguration)];
    [ECOSwizzle swizzleClassMethodWithClass:[self class] fromSelector:@selector(ephemeralSessionConfiguration) toSelector:@selector(echo_ephemeralSessionConfiguration)];
}

+ (NSURLSessionConfiguration *)echo_defaultSessionConfiguration {
    NSURLSessionConfiguration *configuration = [self echo_defaultSessionConfiguration];
    [configuration addEchoNSURLProtocol];
    return configuration;
}

+ (NSURLSessionConfiguration *)echo_ephemeralSessionConfiguration {
    NSURLSessionConfiguration *configuration = [self echo_ephemeralSessionConfiguration];
    [configuration addEchoNSURLProtocol];
    return configuration;
}

- (void)addEchoNSURLProtocol {
    if ([self respondsToSelector:@selector(protocolClasses)] && [self respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray *urlProtocolClasses = [NSMutableArray arrayWithArray:self.protocolClasses];
        Class protoCls = ECONSURLProtocol.class;
        if (![urlProtocolClasses containsObject:protoCls]) {
            [urlProtocolClasses insertObject:protoCls atIndex:0];
        }
        self.protocolClasses = urlProtocolClasses;
    }
}

@end
