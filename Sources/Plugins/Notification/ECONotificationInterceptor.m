//
//  ECONotificationInterceptor.m
//  Pods
//
//  Created by zhanghe on 2019/8/12.
//

#import "ECONotificationInterceptor.h"
#import <UserNotifications/UserNotifications.h>
#import <objc/runtime.h>
#import "ECOSwizzle.h"

static ECONotificationInterceptor *instance = nil;

@interface ECONotificationInterceptor ()

@property (nonatomic, weak) id<UIApplicationDelegate> applicationDelegate;
@property (nonatomic, weak) id<UNUserNotificationCenterDelegate> userNotificationCenterDelegate;

@end

@implementation ECONotificationInterceptor

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[ECONotificationInterceptor alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self hookMethods];
    }
    return self;
}

- (void)hookMethods {
    self.applicationDelegate = [UIApplication sharedApplication].delegate;
    Class applicationDelegateClass = [self.applicationDelegate class];
    
    [self swizzleInstanceMethodWithClass:applicationDelegateClass fromSelector:@selector(application:didReceiveRemoteNotification:) toSelector:@selector(eco_application:didReceiveRemoteNotification:)];
    [self swizzleInstanceMethodWithClass:applicationDelegateClass fromSelector:@selector(application:didReceiveLocalNotification:) toSelector:@selector(eco_application:didReceiveLocalNotification:)];
    
    [self swizzleInstanceMethodWithClass:applicationDelegateClass fromSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:) toSelector:@selector(eco_application:didReceiveRemoteNotification:fetchCompletionHandler:)];
    [self swizzleInstanceMethodWithClass:applicationDelegateClass fromSelector:@selector(application:handleActionWithIdentifier:forLocalNotification:completionHandler:) toSelector:@selector(eco_application:handleActionWithIdentifier:forLocalNotification:completionHandler:)];
    [self swizzleInstanceMethodWithClass:applicationDelegateClass fromSelector:@selector(application:handleActionWithIdentifier:forLocalNotification:withResponseInfo:completionHandler:) toSelector:@selector(eco_application:handleActionWithIdentifier:forLocalNotification:withResponseInfo:completionHandler:)];
    [self swizzleInstanceMethodWithClass:applicationDelegateClass fromSelector:@selector(application:handleActionWithIdentifier:forRemoteNotification:completionHandler:) toSelector:@selector(eco_application:handleActionWithIdentifier:forRemoteNotification:completionHandler:)];
    [self swizzleInstanceMethodWithClass:applicationDelegateClass fromSelector:@selector(application:handleActionWithIdentifier:forRemoteNotification:withResponseInfo:completionHandler:) toSelector:@selector(eco_application:handleActionWithIdentifier:forRemoteNotification:withResponseInfo:completionHandler:)];
    
    if (@available(iOS 10.0, *)) {
        self.userNotificationCenterDelegate = [UNUserNotificationCenter currentNotificationCenter].delegate;
        Class userNotificationDelegateClass = [self.userNotificationCenterDelegate class];
        
        [self swizzleInstanceMethodWithClass:userNotificationDelegateClass fromSelector:@selector(userNotificationCenter:willPresentNotification:withCompletionHandler:) toSelector:@selector(eco_userNotificationCenter:willPresentNotification:withCompletionHandler:)];
    }
    
//    [self testNotification];
//    [self testNotification2];
}

- (void)swizzleInstanceMethodWithClass:(Class)class fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector {
    Method tempMethod = class_getInstanceMethod([self class], toSelector);
    if (class_addMethod(class, toSelector, method_getImplementation(tempMethod), method_getTypeEncoding(tempMethod))) {
        [ECOSwizzle swizzleInstanceMethodWithClass:class fromSelector:fromSelector toSelector:toSelector];
    }
}

- (void)notificationTitle:(NSString *)title detail:(NSString *)detail {
    [self.delegate notificationTitle:title detail:detail];
}

#pragma mark - application delegate

- (void)eco_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self eco_application:application didReceiveRemoteNotification:userInfo];
    [[ECONotificationInterceptor sharedInstance] notificationTitle:@"RemoteNotification" detail:userInfo.description];
}

- (void)eco_application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self eco_application:application didReceiveLocalNotification:notification];
    [[ECONotificationInterceptor sharedInstance] notificationTitle:@"LocalNotification" detail:notification.description];
}

- (void)eco_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [self eco_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    [[ECONotificationInterceptor sharedInstance] notificationTitle:@"RemoteNotification" detail:userInfo.description];
}

- (void)eco_application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)(void))completionHandler {
    [self eco_application:application handleActionWithIdentifier:identifier forLocalNotification:notification completionHandler:completionHandler];
    NSMutableString *detail = [[NSMutableString alloc] init];
    [detail appendFormat:@"Identifier: %@\n", identifier];
    [detail appendFormat:@"Notification: %@\n", notification.description];
    [[ECONotificationInterceptor sharedInstance] notificationTitle:@"LocalNotification" detail:detail];
}

- (void)eco_application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)(void))completionHandler {
    [self eco_application:application handleActionWithIdentifier:identifier forLocalNotification:notification withResponseInfo:responseInfo completionHandler:completionHandler];
    NSMutableString *detail = [[NSMutableString alloc] init];
    [detail appendFormat:@"Identifier: %@\n", identifier];
    [detail appendFormat:@"Notification: %@\n", notification.description];
    [detail appendFormat:@"ResponseInfo: %@\n", responseInfo.description];
    [[ECONotificationInterceptor sharedInstance] notificationTitle:@"LocalNotification" detail:detail];
}

- (void)eco_application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)(void))completionHandler {
    [self eco_application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
    NSMutableString *detail = [[NSMutableString alloc] init];
    [detail appendFormat:@"Identifier: %@\n", identifier];
    [detail appendFormat:@"UserInfo: %@\n", userInfo.description];
    [[ECONotificationInterceptor sharedInstance] notificationTitle:@"RemoteNotification" detail:detail];
}

- (void)eco_application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)(void))completionHandler {
    [self eco_application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo withResponseInfo:responseInfo completionHandler:completionHandler];
    NSMutableString *detail = [[NSMutableString alloc] init];
    [detail appendFormat:@"Identifier: %@\n", identifier];
    [detail appendFormat:@"UserInfo: %@\n", userInfo.description];
    [detail appendFormat:@"ResponseInfo: %@\n", responseInfo.description];
    [[ECONotificationInterceptor sharedInstance] notificationTitle:@"RemoteNotification" detail:detail];
}

#pragma mark - userNotificationCenter delegate

- (void)eco_userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    [self eco_userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
    [[ECONotificationInterceptor sharedInstance] notificationTitle:@"UserNotification" detail:notification.description];
}

#pragma mark - test

- (void)testNotification {
    //创建一个本地通知
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = 0;
    
    notification.alertBody = @"test";
    
    notification.applicationIconBadgeNumber = 1;
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"test" forKey:@"testkey"];
    
    notification.userInfo = userDict;
    
    //请求本地通知 授权
    [self getRequestWithLocalNotificationSleep:notification];
    
}

- (void)getRequestWithLocalNotificationSleep:(UILocalNotification *)notification
{
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
#warning 注册完之后如果不删除，下次会继续存在，即使从模拟器卸载掉也会保留
    
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    });
    
}

- (void)testNotification2 {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              
                          }];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
    }];
    
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.badge = [NSNumber numberWithInt:1];
    content.title = @"test2";
    content.body = @"test22";
    content.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:15 repeats:NO];

    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"request1" content:content trigger:trigger];
    [center addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

@end
