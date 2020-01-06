//
//  ECOCrashPlugin.m
//  EchoSDK
//
//  Created by Lux on 2019/8/26.
//

#import "ECOCrashPlugin.h"
#import "ECOClient.h"
#import "ECOCrashSignalExceptionHandler.h"
#import "ECOCrashUncaughtExceptionHandler.h"
#import "ECOCrashFileManager.h"

#pragma mark - ---| Data Key |---

static NSString *const kPart1 = @"Crash Time";
static NSString *const kPart2 = @"Crash Type";
static NSString *const kPart3 = @"Crash File Path";

@implementation ECOCrashPlugin

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[ECOClient sharedClient] registerPlugin:[self class]];
    });
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *templetData = @[@{@"name":kPart1, @"weight":@(0.3)},
                                 @{@"name":kPart2, @"weight":@(0.3)},
                                 @{@"name":kPart3, @"weight":@(0.4)},
        ];
        [self registerTemplate:ECOUITemplateType_ListDetail data:templetData];
        [self p_registerHandler];
        [self setName:@"崩溃日志"];
    }
    return self;
}

- (void)device:(ECOChannelDeviceInfo *)device didChangedAuthState:(BOOL)isAuthed {
    if (isAuthed) {
        [self p_loadCrashDataAndSendToDevice:device];
    }
}

- (void)p_registerHandler {
    [ECOCrashSignalExceptionHandler registerHandler];
    [ECOCrashUncaughtExceptionHandler registerHandler];
}

- (void)p_loadCrashDataAndSendToDevice:(ECOChannelDeviceInfo *)device {
    NSArray *infos = [ECOCrashFileManager crashFiles:YES];
    NSLog(@"加载崩溃日志文件(%@个)：%@",@(infos.count), infos);
    [infos enumerateObjectsUsingBlock:^(ECOCrashFileInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *one = [self p_listInfoWithFileInfo:obj];
        if (one && self.deviceSendBlock) {
            self.deviceSendBlock(device, one);
        }
    }];
}

- (NSDictionary *)p_listInfoWithFileInfo:(ECOCrashFileInfo *)fileInfo {
    if (!fileInfo ||
        !fileInfo.crashDateString ||
        !fileInfo.crashTypeString ||
        !fileInfo.filePath) {
        return nil;
    }
    NSMutableDictionary *one = @{}.mutableCopy;
    ///< 设置列表展示项
    [one setObject:@{kPart1 : fileInfo.crashDateString,
                     kPart2 : fileInfo.crashTypeString,
                     kPart3 : fileInfo.filePath}
            forKey:@"list"];
    ///< 设置展示内容
    [one setObject:fileInfo.crashInfo forKey:@"detail"];
    return one;
}

@end
