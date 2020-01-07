//
//  ECOMemoryLeakPlugin.m
//  Echo
//
//  Created by yxj on 2019/7/31.
//

#import "ECOMemoryLeakPlugin.h"
#import "ECOMemoryLeakManager.h"
#import "ECOClient.h"

@implementation ECOMemoryLeakPlugin

+ (void)load {
    [[ECOClient sharedClient] registerPlugin:[self class]];
}

- (void)dealloc{
    [self stop];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = @"Memory Leak Detector";
        [self registerTemplate:ECOUITemplateType_ListDetail data:@[@{@"name":@"time",
                                                                     @"weight":@(0.25)
                                                                     },
                                                                   @{@"name":@"title",
                                                                     @"weight":@(0.25)
                                                                     },
                                                                   @{@"name":@"message",
                                                                     @"weight":@(0.5)
                                                                     }]];
        [self startMLeakFinderMonitor];
        
    }
    return self;
}

- (void)startMLeakFinderMonitor {
    __weak typeof(self) weakSelf = self;
   [ECOMemoryLeakManager sharedManager].addBlock = ^(NSDictionary *logDict) {
       NSMutableDictionary *sendData = [NSMutableDictionary dictionary];
       NSMutableDictionary *tmpDictM = [logDict mutableCopy];
       NSString *longMsg = [tmpDictM objectForKey:@"message"];
       NSArray <NSString *> *strs = [longMsg componentsSeparatedByString:@"\""];
       NSString *shortMsg = (strs.count > 1) ? strs[1] : @"Exception occurred, failed to finder retain cycle.";
       [tmpDictM setObject:shortMsg forKey:@"message"];
       //添加列表内容
       [sendData setValue:tmpDictM forKey:@"list"];
       //添加详细内容
       NSMutableString *contentString = [NSMutableString string];
       [contentString appendString:@"检查到内存泄漏:\n\n"];
       [contentString appendFormat:@"time: %@\nLeaked view stack：\n%@\nRetain cycle: \n%@\n",
                            logDict[@"time"] ?: @"",
                            logDict[@"message"] ?: @"\n",
                            logDict[@"additionMsg"] ?: @""];
       [sendData setValue:contentString forKey:@"detail"];
       
       !weakSelf.sendBlock ?: weakSelf.sendBlock(sendData);
   };
}

- (void)stop {
    [ECOMemoryLeakManager sharedManager].addBlock = nil;
}

@end
