//
//  ECONetworkInterceptor.h
//  EchoSDK
//
//  Created by zhanghe on 2019/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ECONetworkInterceptorDelegate <NSObject>

- (void)interceptedWithRequest:(NSURLRequest *)request
                          data:(NSData *)data
                      response:(NSURLResponse *)response
                         error:(NSError *)error
                     startTime:(NSDate *)startTime;

@end

@interface ECONetworkInterceptor : NSObject

@property (nonatomic, weak) id<ECONetworkInterceptorDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)interceptWithRequest:(NSURLRequest *)request
                        data:(NSData *)data
                    response:(NSURLResponse *)response
                       error:(NSError *)error
                   startTime:(NSDate *)startTime;


@end

NS_ASSUME_NONNULL_END
