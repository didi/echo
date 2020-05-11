//
//  ECONSURLProtocol.m
//  EchoSDK
//
//  Created by zhanghe on 2019/8/5.
//

#import "ECONSURLProtocol.h"
#import "ECONetworkInterceptor.h"

static NSString * const kEchoURLProtocolKey = @"kEchoURLProtocolKey";

@interface ECONSURLProtocol () <NSURLSessionDataDelegate>

@property (atomic, strong) NSURLSessionDataTask *dataTask;
@property (atomic, strong) NSURLSessionConfiguration *sessionConfiguration;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSError *error;

@end

@implementation ECONSURLProtocol

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    NSURLRequest *request = task.currentRequest;
    return request == nil ? NO : [self canInitWithRequest:request];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([NSURLProtocol propertyForKey:kEchoURLProtocolKey inRequest:request]) {
        return NO;
    }
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    if (contentType && [contentType containsString:@"multipart/form-data"]) {
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:kEchoURLProtocolKey inRequest:mutableReqeust];
    return [mutableReqeust copy];
}

- (void)startLoading {
    self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.startTime = [NSDate date];
    self.data = [NSMutableData data];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration
                                                          delegate:self
                                                     delegateQueue:nil];

    self.dataTask = [session dataTaskWithRequest:self.request];
    [self.dataTask resume];
}

- (void)stopLoading {
    [[ECONetworkInterceptor sharedInstance] interceptWithRequest:self.request data:self.data response:self.response error:self.error startTime:self.startTime];
    [self.dataTask cancel];
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        self.error = error;
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    [self.data appendData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
    self.response = response;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

@end
