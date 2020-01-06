//
//  ECOWatchdogPlugin.m
//  Pods
//
//  Created by zhanghe on 2019/8/16.
//

#import "ECOWatchdogPlugin.h"
#import "ECOClient.h"

@implementation ECOWatchdogPlugin

+ (void)load {
    [[ECOClient sharedClient] registerPlugin:[self class]];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"主线程卡顿";
        [self registerTemplate:ECOUITemplateType_ListDetail data:@[@{@"name":@"Time",
                                                                     @"weight":@(0.2)
                                                                     },
                                                                   @{@"name":@"Message",
                                                                     @"weight":@(0.8)
                                                                     }]];
        [ECOWatchdog sharedInstance].delegate = self;
    }
    return self;
}

- (void)onReportReceived:(NSString *)report {
    if (!report) {
        return;
    }
    NSArray *reportArr = [report componentsSeparatedByString:@"\n"];
    NSString *message = @"no message";
    for (NSInteger i = 0; i < reportArr.count; i++) {
        NSString *line = reportArr[i];
        NSString *execKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey];
        if ([line containsString:execKey]) {
            message = line;
            NSUInteger loc = [line rangeOfString:@"0x"].location;
            if (loc != NSNotFound) {
                message = [line substringFromIndex:loc];
            }
            break;
        }
    }
    NSDictionary *dict = @{@"list": @{@"Time": [[self dateFormatter] stringFromDate:[NSDate date]],
                                      @"Message": message},
                           @"detail": report};
    !self.sendBlock ?: self.sendBlock(dict);
}

@end
