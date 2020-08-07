//
//  ECOWatchdog.m
//  Pods
//
//  Created by zhanghe on 2019/8/16.
//

#import "ECOWatchdog.h"
#import <BSBacktraceLogger/BSBacktraceLogger.h>

@interface ECOWatchdog ()

@property (nonatomic, strong) dispatch_source_t pingTimer;
@property (nonatomic, strong) dispatch_source_t timeoutTimer;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation ECOWatchdog

+ (instancetype)sharedInstance {
    static ECOWatchdog *instance = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[ECOWatchdog alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = dispatch_queue_create("com.echo.watchdog", DISPATCH_QUEUE_SERIAL);
        [self start];
    }
    return self;
}

- (void)start {
    if (self.pingTimer) {
        dispatch_source_cancel(self.pingTimer);
        self.pingTimer = nil;
    }
    self.pingTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    if (self.pingTimer) {
        uint64_t interval = 1.0 * NSEC_PER_SEC;
        dispatch_source_set_timer(self.pingTimer, dispatch_walltime(NULL, interval), DISPATCH_TIME_FOREVER, 0);
        dispatch_source_set_event_handler(self.pingTimer, ^{
            [self ping];
        });
        dispatch_resume(self.pingTimer);
    }
}

- (void)ping {
    self.timeoutTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    if (self.timeoutTimer) {
        uint64_t interval = 3.0 * NSEC_PER_SEC;
        dispatch_source_set_timer(self.timeoutTimer, dispatch_walltime(NULL, interval), interval, 0);
        dispatch_source_set_event_handler(self.timeoutTimer, ^{
            [self onTimeout];
        });
        dispatch_resume(self.timeoutTimer);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self onPong];
    });
}

- (void)cancelTimeoutTimer {
    if (self.timeoutTimer) {
        dispatch_source_cancel(self.timeoutTimer);
        self.timeoutTimer = nil;
    }
}

- (void)onPong {
    [self cancelTimeoutTimer];
    [self start];
}

- (void)onTimeout {
    [self.delegate onReportReceived:[BSBacktraceLogger bs_backtraceOfMainThread]];
}

@end
