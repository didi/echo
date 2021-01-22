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
@property NSURLSession *session;

@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSMutableData *data;
@property (nonatomic) NSURLResponse *response;
@property (nonatomic) NSError *error;

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
    return mutableReqeust;
}

- (void)startLoading {
    self.startTime = [NSDate date];
    self.data = [NSMutableData.alloc initWithCapacity:1024 * 4];

    NSURLSessionConfiguration *config = NSURLSessionConfiguration.defaultSessionConfiguration;
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];

    NSURLSessionTask *task = [self.session dataTaskWithRequest:self.request];
    [task resume];
}

- (void)stopLoading {
    [[ECONetworkInterceptor sharedInstance] interceptWithRequest:self.request data:self.data response:self.response error:self.error startTime:self.startTime];
    [self.session invalidateAndCancel];
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
