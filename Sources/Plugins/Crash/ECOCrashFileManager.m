//
//  ECOCrashFileManager.m
//  EchoSDK
//
//  Created by Lux on 2019/11/4.
//

#import "ECOCrashFileManager.h"

#pragma mark - ---| ECOCrashFileManager Define |---

/*!
 文件存到 Library/Caches/ 下
 */
#define ECHO_CACHE_DIR [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

/*!
 崩溃日志存储最大值
 */
static const NSInteger kECOCrashFileMaxCount = 20;

/*!
 Caches 下的崩溃日志目录名
 */
static NSString *const kECOCrashDirectory = @"ECOCrash";


#pragma mark - ---| ECOCrashFileManager |---

@implementation ECOCrashFileManager

+ (void)saveCrashType:(ECOCrashType)type info:(NSString *)info {
    ECOCrashFileInfo *crashInfo = [[ECOCrashFileInfo alloc] initWithCrashInfo:info type:type];
    if (!crashInfo) {
        return;
    }
    NSString *directory = [self p_crashDirectory];
    if (![self p_hasDirectory:directory]) {
        return;
    }
    
    BOOL isNeedFIFOStrategy = YES;
    if ( isNeedFIFOStrategy ) {
        NSArray *files = [self crashFiles:YES];
        NSLog(@"经过排序的全部 Crash 文件(%@个)：%@", @(files.count) ,files);
        if (files.count > kECOCrashFileMaxCount) {
            NSInteger count = files.count - kECOCrashFileMaxCount + 1;
            NSRange range = NSMakeRange(files.count - count - 1, count);
            NSArray *list = [files objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            [list enumerateObjectsUsingBlock:^(ECOCrashFileInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self removeFile:obj];
            }];
        }
    }
    [self saveFile:crashInfo toDrictory:directory];
}

+ (NSArray <ECOCrashFileInfo *> *)crashFiles:(BOOL)isSortedByDate {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *directory = [self p_crashDirectory];
    if (!directory) return nil;
    NSError *error = nil;
    NSArray *paths = [manager contentsOfDirectoryAtPath:directory error:&error];
    if (!paths || paths.count == 0) {
        return nil;
    }
    NSLog(@"😁当前目录下的全部文件（%@个）：%@", @(paths.count), paths);
    NSMutableArray *infos = @[].mutableCopy;
    for (NSString *path in paths) {
        NSString *filePath = [directory stringByAppendingPathComponent:path];
        ECOCrashFileInfo *infoModel = [[ECOCrashFileInfo alloc] initWithFilePath:filePath];
        if (infoModel) [infos addObject:infoModel];
    }
    if (infos.count > 0 && isSortedByDate) {
        NSArray *sorted = [infos sortedArrayUsingComparator:^
                           NSComparisonResult(ECOCrashFileInfo *obj1, ECOCrashFileInfo *obj2)
        {
            NSDate *date1 = obj1.crashDate;
            NSDate *data2 = obj2.crashDate;
            NSComparisonResult result = [data2 compare:date1];
            return result;
        }];
        return sorted;
    }
    return infos.copy;
}

#pragma mark - ---| DIRECTORY |---

+ (BOOL)p_hasDirectory:(NSString *)directoryPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:directoryPath];
}

+ (NSString *)p_crashDirectory {
    NSString *directory = [ECHO_CACHE_DIR stringByAppendingPathComponent:kECOCrashDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:directory] == NO) {
        [manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return directory;
}

/*!
 将崩溃信息保存到目录（自己会在内部拼文件名）；
 @warning 仅用于崩溃时在系统的回调中使用，尽可能的少处理逻辑
 */
+ (BOOL)saveFile:(ECOCrashFileInfo *)fileInfo toDrictory:(NSString *)dirctory {
    fileInfo.fileDirctory = dirctory;
    NSString *text = fileInfo.crashInfo;
    NSString *path = fileInfo.filePath;
    NSError *error = nil;
    BOOL success = [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if ( success ) {
        NSLog(@"✅ 保存文件成功：%@", fileInfo);
    } else {
        NSLog(@"❎ 保存文件失败：%@ \nerror: %@", fileInfo, error);
        [self p_saveToUserDefaultWithAction:YES file:fileInfo];
    }
    return success;
}

/*!
 删除文件
 */
+ (BOOL)removeFile:(ECOCrashFileInfo *)fileInfo {
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:fileInfo.filePath error:&error];
    if ( success ) {
        NSLog(@"✅ 删除文件成功：%@", fileInfo);
    } else {
        NSLog(@"❎ 删除文件失败：%@ \nerror: %@", fileInfo, error);
        [self p_saveToUserDefaultWithAction:NO file:fileInfo];
    }
    return success;
}

+ (void)p_saveToUserDefaultWithAction:(BOOL)isSave file:(ECOCrashFileInfo *)fileInfo {
    /*!
     保存本地IO(save & remove)失败的数据
     */
    NSString *boxKey = @"ECO_CRASH_BOX";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *box = [[defaults objectForKey:boxKey] mutableCopy];
    if (box == nil) {
        box = @{}.mutableCopy;
        [defaults setObject:box forKey:boxKey];
    }
    NSString *actionKey = isSave ? @"save" : @"remove";
    NSMutableArray *actionBox = [box[actionKey] mutableCopy];
    if (!actionBox) {
        actionBox = @[].mutableCopy;
        [box setObject:actionBox forKey:actionKey];
    }
    [actionBox addObject:fileInfo];
}

@end
