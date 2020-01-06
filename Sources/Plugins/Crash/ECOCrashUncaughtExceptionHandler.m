//
//  ECOCrashUncaughtExceptionHandler.m
//  EchoSDK
//
//  Created by Lux on 2019/8/26.
//

#import "ECOCrashUncaughtExceptionHandler.h"
#import "ECOCrashFileManager.h"

static NSUncaughtExceptionHandler *_ECOPreviousUncaughtExceptionHandler = NULL;

@implementation ECOCrashUncaughtExceptionHandler

#pragma mark - Register

+ (void)registerHandler {
    /*!
     先保存下之前的崩溃处理函数，之后再调用
     */
    _ECOPreviousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&ECOUncaughtExceptionHandler);
}

#pragma mark - Private

static void ECOUncaughtExceptionHandler(NSException * exception) {
    /*!
     获取整理过的崩溃日志
     */
    NSString *info = [ECOCrashUncaughtExceptionHandler p_renderByException:exception];

    /*!
     保存日志到本地
     */
    [ECOCrashFileManager saveCrashType:ECOCrashTypeUncaught info:info];
    
    /*!
     NSGetUncaughtExceptionHandler 是整个进程共用的异常捕捉回调，所以为了避免重写其他人的异常处理，需要处理完自己的逻辑后再调用之前的逻辑
     */
    if (_ECOPreviousUncaughtExceptionHandler) {
        _ECOPreviousUncaughtExceptionHandler(exception);
    }
    
    // 杀掉程序，这样可以防止同时抛出的SIGABRT被SignalException捕获
    kill(getpid(), SIGKILL);
}

+ (NSString *)p_renderByException:(NSException *)exception {
    ///< 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    ///< 出现异常的原因
    NSString *reason = [exception reason];
    ///< 异常名称
    NSString *name = [exception name];
    ///< 整理好全部的输出内容
    NSString *info = [NSString stringWithFormat:
                      @"程序崩溃信息报告\n\n『崩溃类型』:\n%@\n\n○『崩溃原因』:\n%@\n\n○『崩溃调用栈』:\n%@",
                      name,
                      reason,
                      [stackArray componentsJoinedByString:@"\n"]];
    ///< 待扩展其他内容
    ///< 如可对常规的 exception 类型做详细描述，富文本处理等
    return info;
}

@end
