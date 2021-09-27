//
//  ECOMLeaksMessenger.m
//  EchoSDK
//
//  Created by 陈爱彬 on 2020/1/7. Maintain by 陈爱彬
//  Description 
//

#import "ECOMLeaksMessenger.h"
#import "ECOMemoryLeakManager.h"
#if __has_include("MLeakedObjectProxy.h")
#import "MLeakedObjectProxy.h"
#endif
#import <RSSwizzle/RSSwizzle.h>

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
