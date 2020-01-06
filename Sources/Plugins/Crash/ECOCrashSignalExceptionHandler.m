//
//  ECOCrashSignalExceptionHandler.m
//  EchoSDK
//
//  Created by Lux on 2019/8/26.
//

#import "ECOCrashSignalExceptionHandler.h"
#import <execinfo.h>
#import "ECOCrashFileManager.h"

/*!
 定义 Signal 类型的内核崩溃回调 Block
 */
typedef void (*ECOSignalHandler)(int signal, siginfo_t *info, void *context);

/*!
 定义目前已知的全部 Signal 类型崩溃回调；
 */
static ECOSignalHandler previousABRTECOSignalHandler = NULL;
static ECOSignalHandler previousBUSECOSignalHandler  = NULL;
static ECOSignalHandler previousFPEECOSignalHandler  = NULL;
static ECOSignalHandler previousILLECOSignalHandler  = NULL;
static ECOSignalHandler previousPIPEECOSignalHandler = NULL;
static ECOSignalHandler previousSEGVECOSignalHandler = NULL;
static ECOSignalHandler previousSYSECOSignalHandler  = NULL;
static ECOSignalHandler previousTRAPECOSignalHandler = NULL;

@implementation ECOCrashSignalExceptionHandler

#pragma mark - Register

+ (void)registerHandler {
    /*!
     注册崩溃回调，
     */
    [self p_backupOriginalHandler];
    [self signalRegister];
}

+ (void)p_backupOriginalHandler {
    struct sigaction old_action_abrt;
    sigaction(SIGABRT, NULL, &old_action_abrt);
    if (old_action_abrt.sa_sigaction) {
        previousABRTECOSignalHandler = old_action_abrt.sa_sigaction;
    }
    
    struct sigaction old_action_bus;
    sigaction(SIGBUS, NULL, &old_action_bus);
    if (old_action_bus.sa_sigaction) {
        previousBUSECOSignalHandler = old_action_bus.sa_sigaction;
    }
    
    struct sigaction old_action_fpe;
    sigaction(SIGFPE, NULL, &old_action_fpe);
    if (old_action_fpe.sa_sigaction) {
        previousFPEECOSignalHandler = old_action_fpe.sa_sigaction;
    }
    
    struct sigaction old_action_ill;
    sigaction(SIGILL, NULL, &old_action_ill);
    if (old_action_ill.sa_sigaction) {
        previousILLECOSignalHandler = old_action_ill.sa_sigaction;
    }
    
    struct sigaction old_action_pipe;
    sigaction(SIGPIPE, NULL, &old_action_pipe);
    if (old_action_pipe.sa_sigaction) {
        previousPIPEECOSignalHandler = old_action_pipe.sa_sigaction;
    }
    
    struct sigaction old_action_segv;
    sigaction(SIGSEGV, NULL, &old_action_segv);
    if (old_action_segv.sa_sigaction) {
        previousSEGVECOSignalHandler = old_action_segv.sa_sigaction;
    }
    
    struct sigaction old_action_sys;
    sigaction(SIGSYS, NULL, &old_action_sys);
    if (old_action_sys.sa_sigaction) {
        previousSYSECOSignalHandler = old_action_sys.sa_sigaction;
    }
    
    struct sigaction old_action_trap;
    sigaction(SIGTRAP, NULL, &old_action_trap);
    if (old_action_trap.sa_sigaction) {
        previousTRAPECOSignalHandler = old_action_trap.sa_sigaction;
    }
}

+ (void)signalRegister {
    ECOSignalRegister(SIGABRT);
    ECOSignalRegister(SIGBUS);
    ECOSignalRegister(SIGFPE);
    ECOSignalRegister(SIGILL);
    ECOSignalRegister(SIGPIPE);
    ECOSignalRegister(SIGSEGV);
    ECOSignalRegister(SIGSYS);
    ECOSignalRegister(SIGTRAP);
}

#pragma mark - Private

#pragma mark Register Signal

static void ECOSignalRegister(int signal) {
    struct sigaction action;
    action.sa_sigaction = ECOSignalCrashHandler;
    action.sa_flags = SA_NODEFER | SA_SIGINFO;
    sigemptyset(&action.sa_mask);
    sigaction(signal, &action, 0);
}

#pragma mark SignalCrash Handler

static void ECOSignalCrashHandler(int signal, siginfo_t* info, void* context) {
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:@"Signal Exception:\n"];
    [mstr appendString:[NSString stringWithFormat:@"Signal %@ was raised.\n", ECOSignalName(signal)]];
    [mstr appendString:@"Call Stack:\n"];
    
    //    void* callstack[128];
    //    int i, frames = backtrace(callstack, 128);
    //    char** strs = backtrace_symbols(callstack, frames);
    //    for (i = 0; i <frames; ++i) {
    //        [mstr appendFormat:@"%s\n", strs[i]];
    //    }
    
    // 这里过滤掉第一行日志
    // 因为注册了信号崩溃回调方法，系统会来调用，将记录在调用堆栈上，因此此行日志需要过滤掉
    for (NSUInteger index = 1; index < NSThread.callStackSymbols.count; index++) {
        NSString *str = [NSThread.callStackSymbols objectAtIndex:index];
        [mstr appendString:[str stringByAppendingString:@"\n"]];
    }
    
    [mstr appendString:@"threadInfo:\n"];
    [mstr appendString:[[NSThread currentThread] description]];
    
    // 保存崩溃日志
    [ECOCrashFileManager saveCrashType:ECOCrashTypeSignal info:[NSString stringWithString:mstr]];
    
    ECOClearSignalRigister();
    
    // 调用之前崩溃的回调函数
    previousECOSignalHandler(signal, info, context);
    
    kill(getpid(), SIGKILL);
}

#pragma mark Signal To Name

static NSString *ECOSignalName(int signal) {
    NSString *signalName;
    switch (signal) {
        case SIGABRT:
            signalName = @"SIGABRT";
            break;
        case SIGBUS:
            signalName = @"SIGBUS";
            break;
        case SIGFPE:
            signalName = @"SIGFPE";
            break;
        case SIGILL:
            signalName = @"SIGILL";
            break;
        case SIGPIPE:
            signalName = @"SIGPIPE";
            break;
        case SIGSEGV:
            signalName = @"SIGSEGV";
            break;
        case SIGSYS:
            signalName = @"SIGSYS";
            break;
        case SIGTRAP:
            signalName = @"SIGTRAP";
            break;
        default:
            break;
    }
    return signalName;
}

#pragma mark Previous Signal

static void previousECOSignalHandler(int signal, siginfo_t *info, void *context) {
    ECOSignalHandler previousECOSignalHandler = NULL;
    switch (signal) {
        case SIGABRT:
            previousECOSignalHandler = previousABRTECOSignalHandler;
            break;
        case SIGBUS:
            previousECOSignalHandler = previousBUSECOSignalHandler;
            break;
        case SIGFPE:
            previousECOSignalHandler = previousFPEECOSignalHandler;
            break;
        case SIGILL:
            previousECOSignalHandler = previousILLECOSignalHandler;
            break;
        case SIGPIPE:
            previousECOSignalHandler = previousPIPEECOSignalHandler;
            break;
        case SIGSEGV:
            previousECOSignalHandler = previousSEGVECOSignalHandler;
            break;
        case SIGSYS:
            previousECOSignalHandler = previousSYSECOSignalHandler;
            break;
        case SIGTRAP:
            previousECOSignalHandler = previousTRAPECOSignalHandler;
            break;
        default:
            break;
    }
    if (previousECOSignalHandler) {
        previousECOSignalHandler(signal, info, context);
    }
}

#pragma mark Clear

static void ECOClearSignalRigister() {
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE , SIG_DFL);
    signal(SIGBUS , SIG_DFL);
    signal(SIGTRAP, SIG_DFL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL , SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    signal(SIGSYS , SIG_DFL);
}

@end
