//
//  ECOWatchdog.h
//  Pods
//
//  Created by zhanghe on 2019/8/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ECOWatchdogDelegate <NSObject>

- (void)onReportReceived:(NSString *)report;

@end

@interface ECOWatchdog : NSObject

@property (nonatomic, weak) id <ECOWatchdogDelegate> delegate;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
