//
//  ECONotificationInterceptor.h
//  Pods
//
//  Created by zhanghe on 2019/8/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ECONotificationInterceptorDelegate <NSObject>

- (void)notificationTitle:(NSString *)title detail:(NSString *)detail;

@end

@interface ECONotificationInterceptor : NSObject

@property (nonatomic, weak) id<ECONotificationInterceptorDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)notificationTitle:(NSString *)title detail:(NSString *)detail;

@end

NS_ASSUME_NONNULL_END
