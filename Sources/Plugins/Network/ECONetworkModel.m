//
//  ECONetworkModel.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/4. Maintain by 陈爱彬
//  Description 
//

#import "ECONetworkModel.h"

@implementation ECONetworkModel

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.urlString forKey:@"url"];
    [dict setValue:self.title forKey:@"title"];
    [dict setValue:self.baseURL forKey:@"baseURL"];
    [dict setValue:self.path forKey:@"path"];
    [dict setValue:self.httpMethod forKey:@"method"];
    [dict setValue:self.timeout forKey:@"timeout"];
    [dict setValue:@(self.code).stringValue forKey:@"code"];
    [dict setValue:self.headers forKey:@"headers"];
    [dict setValue:self.urlParams forKey:@"urlParams"];
    [dict setValue:self.responseHeader forKey:@"responseHeader"];
    [dict setValue:self.content forKey:@"content"];
    [dict setValue:self.requestBody forKey:@"body"];
    [dict setValue:self.startDate forKey:@"startDate"];
    [dict setValue:[NSDate date] forKey:@"endDate"];
    if (self.error) {
        [dict setValue:self.error.description forKey:@"error"];
    }
    return dict;
}
@end
