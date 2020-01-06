//
//  DCEagleLogPlugin.m
//  DCAppDevTool
//
//  Created by 陈爱彬 on 2019/5/29. Maintain by 陈爱彬
//  Description 
//

#import "ECONSLogPlugin.h"
#import "ECONSLogManager.h"
#import "ECOClient.h"

@implementation ECONSLogPlugin

+ (void)load {
    [[ECOClient sharedClient] registerPlugin:[self class]];
}

- (void)dealloc
{
    [self stop];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = @"NSLog日志";
        self.cacheNum = 10;
        [self registerTemplate:ECOUITemplateType_ListDetail
                          data:@[
                                 @{ @"name": @"time",
                                    @"weight": @(0.3)
                                    },
                                 @{ @"name": @"content",
                                    @"weight": @(0.7)
                                    }
                                 ]];
        
        [self startNSLogMonitor];
    }
    return self;
}

- (NSString *)p_firstUsefulLine:(NSString *)originalStr {
    NSString *logContent = originalStr;
    //过滤掉开头的空白符等信息
    logContent = [logContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRange firstLineRange = [logContent rangeOfString:@"\n"];
    if (firstLineRange.location != NSNotFound) {
        logContent = [logContent substringWithRange:NSMakeRange(0, firstLineRange.location)];
    }
    return logContent;
}

- (void)startNSLogMonitor {
    __weak typeof(self) weakSelf = self;
    [ECONSLogManager shared].addBlock = ^(NSDictionary *logDict) {
        NSMutableDictionary *sendData = [NSMutableDictionary dictionary];
        NSMutableDictionary *tmpDictM = [NSMutableDictionary dictionary];
        NSString *firstLineStr = [self p_firstUsefulLine:logDict[@"log"]];
        [tmpDictM setObject:firstLineStr?:@"" forKey:@"content"];
        [tmpDictM setObject:logDict[@"time"]?:@"" forKey:@"time"];
        //添加列表内容
        [sendData setValue:tmpDictM forKey:@"list"];
        //添加详细内容
        NSMutableString *contentString = [NSMutableString string];
        [contentString appendString:@"NSLog 记录:\n\n"];
        [contentString appendFormat:@"time: %@\nLog content：\n%@\n",
                             logDict[@"time"] ?: @"",
                             logDict[@"log"] ?: @"\n"
                             ];
        [sendData setValue:contentString forKey:@"detail"];
        
        !weakSelf.sendBlock ?: weakSelf.sendBlock(sendData);
    };
}

- (void)stop {
    [ECONSLogManager shared].addBlock = nil;
}
@end
