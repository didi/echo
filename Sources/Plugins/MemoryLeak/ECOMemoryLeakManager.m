//
//  ECOMemoryLeakManager.m
//  Echo
//
//  Created by yxj on 2019/7/31.
//

#import "ECOMemoryLeakManager.h"

@interface ECOMemoryLeakManager()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ECOMemoryLeakManager

+ (instancetype)sharedManager {
    static ECOMemoryLeakManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ECOMemoryLeakManager alloc] init];
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

@end
