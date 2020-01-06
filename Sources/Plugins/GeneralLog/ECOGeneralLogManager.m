//
//  ECOGeneralLogManager.m
//  EchoSDK
//
//  Created by yxj on 2019/8/6.
//

#import "ECOGeneralLogManager.h"

@interface ECOGeneralLogManager()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ECOGeneralLogManager

+ (instancetype)sharedManager {
    static ECOGeneralLogManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ECOGeneralLogManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)addRecord:(NSDictionary *)rec {
    if (self.addBlock) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        [dictM addEntriesFromDictionary:rec];
        NSDate *date = [NSDate date];
        NSString *time = [self.dateFormatter stringFromDate:date];
        [dictM setValue:time forKey:@"time"];
        self.addBlock(dictM);
    }
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

- (void)addGeneralLog:(NSString *)log{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictM setObject:@"general" forKey:@"logType"];
    if (log) [dictM setObject:log forKey:@"log"];
    [self addRecord:dictM.copy];
}
- (void)addVerboseLog:(NSString *)log{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictM setObject:@"verbose" forKey:@"logType"];
    if (log) [dictM setObject:log forKey:@"log"];
    [self addRecord:dictM.copy];
}

- (void)addDebugLog:(NSString *)log {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictM setObject:@"debug" forKey:@"logType"];
    if (log) [dictM setObject:log forKey:@"log"];
    [self addRecord:dictM.copy];
}

- (void)addInfoLog:(NSString *)log {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictM setObject:@"info" forKey:@"logType"];
    if (log) [dictM setObject:log forKey:@"log"];
    [self addRecord:dictM.copy];
}

- (void)addWarnLog:(NSString *)log {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictM setObject:@"warn" forKey:@"logType"];
    if (log) [dictM setObject:log forKey:@"log"];
    [self addRecord:dictM.copy];
}

- (void)addErrorLog:(NSString *)log {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictM setObject:@"error" forKey:@"logType"];
    if (log) [dictM setObject:log forKey:@"log"];
    [self addRecord:dictM.copy];
}

- (void)addLog:(NSString *)log customType:(NSString *)type {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:3];
    if (type) [dictM setObject:type forKey:@"logType"];
    if (log) [dictM setObject:log forKey:@"log"];
    [self addRecord:dictM.copy];
}


@end
