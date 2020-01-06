//
//  ECOCrashFileInfo.m
//  EchoSDK
//
//  Created by Lux on 2019/11/4.
//

#import "ECOCrashFileInfo.h"

#pragma mark - ---| Define Const String |---

static NSString *const kFileSeparator = @"_";
static NSString *const kFileType      = @"CRASH";
static NSString *const kFilePrefix    = @"ECO";
static NSString *const kFileSuffix    = @"txt";
static NSString *const kCrashSignal   = @"Signal";
static NSString *const kCrashUncaught = @"Uncaught";

#pragma mark - ---| ECOCrashFileInfo |---

@interface ECOCrashFileInfo()
@property (nonatomic, copy, readwrite) NSDate *crashDate;
@end
@implementation ECOCrashFileInfo

- (instancetype)initWithFilePath:(NSString *)filePath {
    if (!filePath) return nil;
    self = [super init];
    if (self) {
        NSString *fileName = [[filePath pathComponents] lastObject];
        NSString *dirctory = [filePath stringByDeletingLastPathComponent];
        if (!fileName || !dirctory) return nil;
        
        NSUInteger length = 4;///< @"." + kFileSuffix => @".txt"
        fileName = [fileName substringWithRange:NSMakeRange(0, fileName.length - length)];
        
        /*!
         e.g. parts = @[@"ECO", @"CRASH", @"Signal", @"2019-11-04 18:18:05"]
         */
        NSArray *parts = [fileName componentsSeparatedByString:kFileSeparator];
        if (!(parts.count == 4) ||
            ![parts[0] isEqual:kFilePrefix] ||
            ![parts[1] isEqual:kFileType]) {
            return nil;
        }
        
        _crashType = [self.class p_typeFrom:parts[2]];
        _crashDate = [self.class p_dateFrom:parts[3]];
        _crashInfo = [self.class p_infoFrom:filePath];
        _fileDirctory = dirctory;
    }
    return self;
}

- (instancetype)initWithCrashInfo:(NSString *)crashInfo type:(ECOCrashType)type {
    self = [super init];
    if (self) {
        _crashType = type;
        _crashDate = [NSDate date];
        _crashInfo = crashInfo;
    }
    return self;
}

- (NSString *)crashDateString {
    if (!self.crashDate) return nil;
    NSDateFormatter *one = [self.class p_dateFormattere];
    NSString *string = [one stringFromDate:self.crashDate];
    return string;
}

+ (NSDateFormatter *)p_dateFormattere {
    static NSDateFormatter *one = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        one = [[NSDateFormatter alloc] init];
        one.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        one.timeZone = [NSTimeZone systemTimeZone];
    });
    return one;
}

+ (NSDate *)p_dateFrom:(NSString *)string {
    NSDateFormatter *one = [self p_dateFormattere];
    NSDate *date = [one dateFromString:string];
    return date;
}

- (NSString *)fileName {
    NSArray *parts = @[kFilePrefix,
                       kFileType,
                       self.crashTypeString,
                       self.crashDateString
    ];
    NSString *name = [parts componentsJoinedByString:kFileSeparator];
    name = [name stringByAppendingFormat:@".%@", kFileSuffix];
    return name;
}

+ (NSString *)p_infoFrom:(NSString *)path {
    NSString *one = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return one;
}

+ (ECOCrashType)p_typeFrom:(NSString *)string {
    if ([string isEqualToString:kCrashUncaught]) {
        return ECOCrashTypeUncaught;
    } else {
        return ECOCrashTypeSignal;
    }
}

- (NSString *)crashTypeString {
    if (self.crashType == ECOCrashTypeUncaught) {
        return kCrashUncaught;
    } else {
        return kCrashSignal;
    }
}

- (NSString *)filePath {
    return [self.fileDirctory stringByAppendingPathComponent:self.fileName];
}

- (NSString *)description {
    return [NSString stringWithFormat:
            @"%@ : %p => [Crash Date : %@] [Crash Type : %@] [File Name : %@]",
            self.class,
            self,
            self.crashDateString,
            self.crashTypeString,
            self.fileName];
}

@end
