//
//  ECONetworkPlugin.m
//  EchoSDK
//
//  Created by zhanghe on 2019/8/2.
//

#import "ECONetworkPlugin.h"
#import "ECONSURLProtocol.h"
#import "ECOClient.h"

static NSDateFormatter *dateFormatter = nil;

@implementation ECONetworkPlugin

+ (void)load {
    [[ECOClient sharedClient] registerPlugin:[self class]];
}

- (void)dealloc {
    [self stop];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = @"网络请求";
        [self registerTemplate:ECOUITemplateType_Network data:nil];
        [NSURLProtocol registerClass:[ECONSURLProtocol class]];
        [[ECONetworkInterceptor sharedInstance] setDelegate:self];
    }
    return self;
}

- (void)start {

}

- (void)stop {
    
}

- (void)interceptedWithRequest:(NSURLRequest *)request data:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error startTime:(nonnull NSDate *)startTime {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[request.URL absoluteString] forKey:@"url"];
    
    NSString *titleString = [request.URL.host stringByAppendingPathComponent:request.URL.path];
    titleString = [NSString stringWithFormat:@"%@://%@",request.URL.scheme, titleString];
    [dict setValue:titleString forKey:@"title"];
    
    [dict setValue:request.HTTPMethod forKey:@"method"];
    [dict setValue:[[self dateFormatter] stringFromDate:startTime] forKey:@"startDate"];
    [dict setValue:request.allHTTPHeaderFields forKey:@"headers"];
    [dict setValue:request.URL.path forKey:@"path"];
    
    NSString *query = request.URL.query;
    NSArray *queryItems = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *urlParams = [NSMutableDictionary dictionary];
    [queryItems enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *items = [obj componentsSeparatedByString:@"="];
        if (items.count == 2) {
            [urlParams setValue:items[1] forKey:items[0]];
        }
    }];
    [dict setValue:urlParams forKey:@"urlParams"];
    if (request.HTTPBody) {
        [dict setValue:request.HTTPBody forKey:@"body"];
    }
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        [dict setValue:@(urlResponse.statusCode).stringValue forKey:@"code"];
        [dict setValue:urlResponse.allHeaderFields forKey:@"responseHeader"];
    } else {
        NSLog(@"%@", response);
    }
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
    [dict setValue:content forKey:@"content"];
    [dict setValue:error.description forKey:@"error"];
    
    !self.sendBlock ?: self.sendBlock(dict);
}

- (NSDateFormatter *)dateFormatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm:ss";
    }
    return dateFormatter;
}

@end
