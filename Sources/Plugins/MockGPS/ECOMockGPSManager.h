//
//  ECOMockGPSManager.h
//  EchoSDK
//
//  Created by zhanghe on 2019/8/22.
//

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECOMockGPSManager : NSObject

+ (instancetype)sharedInstance;
- (void)addLocationManager:(id)manager delegate:(id)delegate;
- (void)mockLocation:(CLLocation *)location;

@end

NS_ASSUME_NONNULL_END
