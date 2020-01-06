//
//  MLeaksMessenger+Echo.m
//  Echo
//
//  Created by yxj on 2019/7/31.
//

#import "MLeaksMessenger+Echo.h"
#import "MLeakedObjectProxy.h"
#import "ECOMemoryLeakManager.h"
#if __has_include(<RSSwizzle/RSSwizzle.h>)
#import <RSSwizzle/RSSwizzle.h>
#endif
#if __has_include(<FBRetainCycleDetector/FBRetainCycleDetector.h>)
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#endif

@implementation MLeaksMessenger (Echo)

+ (void)load {    
#if __has_include(<RSSwizzle/RSSwizzle.h>)
    RSSwizzleClassMethod(MLeaksMessenger,
                         @selector(alertWithTitle:message:delegate:additionalButtonTitle:),
                             RSSWReturnType(void),
                             RSSWArguments(NSString *title, NSString *message, id delegate, NSString *additionalButtonTitle),
                             RSSWReplacement({
        
        BOOL turnOffMLeakFinderAlertForEcho = [[NSUserDefaults standardUserDefaults] boolForKey:@"DCTurnOffMLeakAlertKey"];
        if (turnOffMLeakFinderAlertForEcho) {
            return;//do nothing to achieve turn off alert
        }
        //call original
        RSSWCallOriginal(title, message, delegate, additionalButtonTitle);
        
        __block NSString *additionMsg = nil;
        //do additional work
        if (!delegate) {
            [self addRecordWithTitle:title message:message additionMsg:additionMsg];
        } else {
#if __has_include(<FBRetainCycleDetector/FBRetainCycleDetector.h>)
            MLeakedObjectProxy *proxy = (MLeakedObjectProxy *)delegate;
            id object = [proxy valueForKey:@"object"];//获取 object
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                FBRetainCycleDetector *detector = [FBRetainCycleDetector new];
                [detector addCandidate:object];
                NSSet *retainCycles = [detector findRetainCyclesWithMaxCycleLength:20];
                BOOL hasFound = NO;
                for (NSArray *retainCycle in retainCycles) {
                    NSInteger index = 0;
                    for (FBObjectiveCGraphElement *element in retainCycle) {
                        if (element.object == object) {
                            NSArray *shiftedRetainCycle = [self shiftArray:retainCycle toIndex:index];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                additionMsg = [NSString stringWithFormat:@"%@", shiftedRetainCycle];
                                [self addRecordWithTitle:title message:message additionMsg:additionMsg];
                            });
                            hasFound = YES;
                            break;
                        }
                        ++index;
                    }
                    if (hasFound) break;
                }
                if (!hasFound) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        additionMsg = @"Fail to find a retain cycle";
                        [self addRecordWithTitle:title message:message additionMsg:additionMsg];
                    });
                }
            });
#endif
        }
    }));
#endif
}

+ (void)addRecordWithTitle:(NSString *)title
                   message:(NSString *)message
               additionMsg:(NSString *)additionMsg {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    if(title)   [dictM setObject:title forKey:@"title"];
    if(message) [dictM setObject:message forKey:@"message"];
    if(additionMsg) [dictM setObject:additionMsg forKey:@"additionMsg"];
    [[ECOMemoryLeakManager sharedManager] addRecord:dictM.copy];
}

+ (NSArray *)shiftArray:(NSArray *)array toIndex:(NSInteger)index {
    if (index == 0) {
        return array;
    }
    
    NSRange range = NSMakeRange(index, array.count - index);
    NSMutableArray *result = [[array subarrayWithRange:range] mutableCopy];
    [result addObjectsFromArray:[array subarrayWithRange:NSMakeRange(0, index)]];
    return result;
}

@end
