//
//  ECONotificationPlugin.m
//  Pods
//
//  Created by zhanghe on 2019/8/12.
//

#import "ECONotificationPlugin.h"
#import "ECOClient.h"

static NSDateFormatter *dateFormatter = nil;

@implementation ECONotificationPlugin

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
        self.name = @"Notification";
        [self registerTemplate:ECOUITemplateType_ListDetail data:@[@{@"name":@"Time",
                                                                     @"weight":@(0.2)
                                                                     },
                                                                   @{@"name":@"Notification",
                                                                     @"weight":@(0.8)
                                                                     }]];
        [self start];
    }
    return self;
}

- (void)start {
    [ECONotificationInterceptor sharedInstance].delegate = self;
}

- (void)stop {
    
}

- (void)notificationTitle:(NSString *)title detail:(NSString *)detail {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *list = [NSMutableDictionary dictionary];
    [list setValue:[[self dateFormatter] stringFromDate:[NSDate date]] forKey:@"Time"];
    [list setValue:title forKey:@"Notification"];
    [data setValue:list forKey:@"list"];
    [data setValue:detail forKey:@"detail"];
    !self.sendBlock ?: self.sendBlock(data);
}

- (NSDateFormatter *)dateFormatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm:ss";
    }
    return dateFormatter;
}

@end
