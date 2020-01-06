//
//  ECOGeneralLogPlugin.m
//  EchoSDK
//
//  Created by yxj on 2019/8/6.
//

#import "ECOGeneralLogPlugin.h"
#import "ECOGeneralLogManager.h"
#import "ECOClient.h"

@implementation ECOGeneralLogPlugin

+ (void)load {
    [[ECOClient sharedClient] registerPlugin:[self class]];
}

- (void)dealloc{
    [self stop];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = @"General Log";
        [self registerTemplate:ECOUITemplateType_ListDetail data:@[@{@"name":@"time",
                                                                     @"weight":@(0.2)
                                                                     },
                                                                   @{@"name":@"logType",
                                                                     @"weight":@(0.3)
                                                                     },
                                                                   @{@"name":@"log",
                                                                     @"weight":@(0.5)
                                                                     }]];
        [self startMonitor];
        
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

- (void)startMonitor {
    __weak typeof(self) weakSelf = self;
   [ECOGeneralLogManager sharedManager].addBlock = ^(NSDictionary *logDict) {
       NSMutableDictionary *sendData = [NSMutableDictionary dictionary];
       //添加列表内容
       NSMutableDictionary *tmpDictM = [NSMutableDictionary dictionary];
       NSString *firstLineStr = [self p_firstUsefulLine:logDict[@"log"]];
       [tmpDictM setObject:firstLineStr?:@"" forKey:@"log"];
       [tmpDictM setObject:logDict[@"logType"]?:@"" forKey:@"logType"];
       [tmpDictM setObject:logDict[@"time"]?:@"" forKey:@"time"];
       [sendData setValue:tmpDictM forKey:@"list"];
       //添加详细内容
       NSMutableString *contentString = [NSMutableString string];
       [contentString appendString:@"日志记录:\n\n"];
       [contentString appendFormat:@"time: %@\nLog type：%@\nLog content: \n%@\n",
                            logDict[@"time"] ?: @"",
                            logDict[@"logType"] ?: @"\n",
                            logDict[@"log"] ?: @""];
       [sendData setValue:contentString forKey:@"detail"];
       
       !weakSelf.sendBlock ?: weakSelf.sendBlock(sendData);
   };
}

- (void)stop {
    [ECOGeneralLogManager sharedManager].addBlock = nil;
}

@end
