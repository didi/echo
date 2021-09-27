//
//  ECONSLogManager.m
//  Echo
//
//  Created by 陈爱彬 on 2019/5/29. Maintain by 陈爱彬
//  Description 
//

#import "ECONSLogManager.h"
#import "ECOFishhook.h"

//函数指针，用来保存原始的函数的地址
static void(*old_nslog)(NSString *format, ...);

//新的NSLog
void echoNSLog(NSString *format, ...){
    
    va_list vl;
    va_start(vl, format);
    NSString* str = [[NSString alloc] initWithFormat:format arguments:vl];
    va_end(vl);
    
    [[ECONSLogManager shared] addNSLog:str];
    //再调用原来的nslog
    //old_nslog(str);
    old_nslog(@"%@",str);
}

@interface ECONSLogManager()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation ECONSLogManager

+ (instancetype)shared {
    static ECONSLogManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ECONSLogManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self hookNSLog];
    }
    return self;
}

- (void)hookNSLog {
    //定义rebinding结构体
    struct rebinding nslogBind;
    //函数名称
    nslogBind.name = "NSLog";
    //新的函数地址
    nslogBind.replacement = echoNSLog;
    //保存原始函数地址的变量的指针
    nslogBind.replaced = (void *)&old_nslog;
    
    //数组
    struct rebinding rebs[]={nslogBind};
    
    /*
     arg1:存放rebinding结构体的数组
     arg2:数组的长度
     */
    rebind_symbols(rebs, 1);
}

- (void)addNSLog:(NSString *)log {
    if (self.addBlock) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:log forKey:@"log"];
        NSDate *date = [NSDate date];
        NSString *time = [self.dateFormatter stringFromDate:date];
        [dict setValue:time forKey:@"time"];
        self.addBlock(dict);
    }
}

#pragma mark - getters
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

@end
