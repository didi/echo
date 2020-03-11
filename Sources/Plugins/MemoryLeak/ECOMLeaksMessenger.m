//
//  ECOMLeaksMessenger.m
//  EchoSDK
//
//  Created by 陈爱彬 on 2020/1/7. Maintain by 陈爱彬
//  Description 
//

#import "ECOMLeaksMessenger.h"
#import "ECOMemoryLeakManager.h"
#import <MLeaksFinder/MLeakedObjectProxy.h>
#import <RSSwizzle/RSSwizzle.h>
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>

@implementation ECOMLeaksMessenger

+ (void)load {
    RSSwizzleClassMethod(NSClassFromString(@"MLeaksMessenger"),
                         @selector(alertWithTitle:message:delegate:additionalButtonTitle:),
                             RSSWReturnType(void),
                             RSSWArguments(NSString *title, NSString *message, id delegate, NSString *additionalButtonTitle),
                             RSSWReplacement({
        //call original
        RSSWCallOriginal(title, message, delegate, additionalButtonTitle);
        
        __block NSString *additionMsg = nil;
        //do additional work
        if (!delegate) {
            [ECOMLeaksMessenger addRecordWithTitle:title message:message additionMsg:additionMsg];
        } else {
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
                            NSArray *shiftedRetainCycle = [ECOMLeaksMessenger shiftArray:retainCycle toIndex:index];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                additionMsg = [NSString stringWithFormat:@"%@", shiftedRetainCycle];
                                [ECOMLeaksMessenger addRecordWithTitle:title message:message additionMsg:additionMsg];
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
                        [ECOMLeaksMessenger addRecordWithTitle:title message:message additionMsg:additionMsg];
                    });
                }
            });
        }
    }));
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
