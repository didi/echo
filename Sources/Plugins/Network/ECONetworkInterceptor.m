//
//  ECONetworkInterceptor.m
//  EchoSDK
//
//  Created by zhanghe on 2019/8/7.
//

#import "ECONetworkInterceptor.h"

static ECONetworkInterceptor *instance = nil;

@implementation ECONetworkInterceptor

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[ECONetworkInterceptor alloc] init];
    });
    return instance;
}

- (void)interceptWithRequest:(NSURLRequest *)request data:(NSData *)data response:(NSURLResponse *)response error:(nonnull NSError *)error startTime:(nonnull NSDate *)startTime {
    [self.delegate interceptedWithRequest:request data:data response:response error:error startTime:startTime];
}

@end
