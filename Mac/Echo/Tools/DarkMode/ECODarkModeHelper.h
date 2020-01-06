//
//  ECODarkModeHelper.h
//  Echo
//
//  Created by 陈爱彬 on 2019/7/12. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECODarkModeHelper : NSObject

+ (instancetype)shared;

/**
 注册Dark Mode变更回调

 @param obj 要注册的对象，可以是ViewController或view，这里是弱引用
 @param eventHandler 变更时的回调，这里是强引用
 @param flag 是否立即回调eventHandler
 */
- (void)subscribeDarkModeChangedEvent:(id)obj
                              handler:(void(^)(BOOL isDarkMode))eventHandler
                          immediately:(BOOL)flag;


/**
 取消注册Dark Mode变更回调，可在dealloc里调用该方法

 @param obj 之前注册的对象
 */
- (void)unsubscribeDarkModeChangedEvent:(id)obj;


/**
 是否是Dark Mode

 @return 当前系统是否为深色模式
 */
- (BOOL)isDarkMode;

@end

NS_ASSUME_NONNULL_END
