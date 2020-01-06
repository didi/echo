//
//  ECOCrashFileManager.h
//  EchoSDK
//
//  Created by Lux on 2019/11/4.
//

#import <Foundation/Foundation.h>
#import "ECOCrashFileInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ECOCrashFileManager : NSObject

/*!
 用于崩溃时本地写入一个崩溃文本
 */
+ (void)saveCrashType:(ECOCrashType)type info:(NSString *)info;

/*!
 获得已缓存的崩溃日志
 @param isSortedByDate : 是否根据日期进行排序
 */
+ (NSArray <ECOCrashFileInfo *> *)crashFiles:(BOOL)isSortedByDate ;

@end

NS_ASSUME_NONNULL_END
