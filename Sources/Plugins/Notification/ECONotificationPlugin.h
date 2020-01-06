//
//  ECONotificationPlugin.h
//  Pods
//
//  Created by zhanghe on 2019/8/12.
//

#import "ECOBasePlugin.h"
#import "ECONotificationInterceptor.h"

NS_ASSUME_NONNULL_BEGIN

@interface ECONotificationPlugin : ECOBasePlugin <ECONotificationInterceptorDelegate>

@end

NS_ASSUME_NONNULL_END
