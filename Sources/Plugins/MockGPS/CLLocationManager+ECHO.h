//
//  CLLocationManager+ECHO.h
//  EchoSDK
//
//  Created by zhanghe on 2019/8/22.
//

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLLocationManager (ECHO)

- (void)echo_setDelegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
