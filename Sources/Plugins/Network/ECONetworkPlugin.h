//
//  ECONetworkPlugin.h
//  EchoSDK
//
//  Created by zhanghe on 2019/8/2.
//

#import "ECOBasePlugin.h"
#import "ECONetworkInterceptor.h"

NS_ASSUME_NONNULL_BEGIN

@interface ECONetworkPlugin : ECOBasePlugin <ECONetworkInterceptorDelegate>

@end

NS_ASSUME_NONNULL_END
