//
//  ECOMockGPSManager.m
//  EchoSDK
//
//  Created by zhanghe on 2019/8/22.
//

#import "ECOMockGPSManager.h"
#import "ECOSwizzle.h"
#import "CLLocationManager+ECHO.h"

@interface ECOMockGPSManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMapTable *locationDelegateTable;

@end

@implementation ECOMockGPSManager

+ (void)load {
    [ECOSwizzle swizzleInstanceMethodWithClass:[CLLocationManager class] fromSelector:@selector(setDelegate:) toSelector:@selector(echo_setDelegate:)];
}

+ (instancetype)sharedInstance {
    static ECOMockGPSManager *instance = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[ECOMockGPSManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationDelegateTable = [NSMapTable weakToWeakObjectsMapTable];
    }
    return self;
}

- (void)addLocationManager:(id)manager delegate:(id)delegate {
    [self.locationDelegateTable setObject:delegate forKey:manager];
}

- (void)mockLocation:(CLLocation *)location {
    if (location) {
        [self notifyLocations:@[location]];
    }
}

- (void)notifyLocations:(NSArray<CLLocation *> *)locations {
    NSEnumerator *enumerator = [self.locationDelegateTable keyEnumerator];
    for (id mgr in [enumerator allObjects]) {
        id delegate = [self.locationDelegateTable objectForKey:mgr];
        if ([delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
            [delegate locationManager:mgr didUpdateLocations:locations];
        }
    }
}

- (void)notify:(CLLocationManager *)manager block:(void (^)(id<CLLocationManagerDelegate> delegate))block {
    id delegate = [self.locationDelegateTable objectForKey:manager];
    if (block) {
        block(delegate);
    }
}

#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self notify:manager block:^(id<CLLocationManagerDelegate> delegate) {
        if ([delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
            [delegate locationManager:manager didUpdateLocations:locations];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self notify:manager block:^(id<CLLocationManagerDelegate> delegate) {
        if ([delegate respondsToSelector:@selector(locationManager:didChangeAuthorizationStatus:)]) {
            [delegate locationManager:manager didChangeAuthorizationStatus:status];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self notify:manager block:^(id<CLLocationManagerDelegate> delegate) {
        if ([delegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
            [delegate locationManager:manager didFailWithError:error];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    [self notify:manager block:^(id<CLLocationManagerDelegate> delegate) {
        if ([delegate respondsToSelector:@selector(locationManager:didUpdateHeading:)]) {
            [delegate locationManager:manager didUpdateHeading:newHeading];
        }
    }];
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    [self notify:manager block:^(id<CLLocationManagerDelegate> delegate) {
        if ([delegate respondsToSelector:@selector(locationManagerDidPauseLocationUpdates:)]) {
            [delegate locationManagerDidPauseLocationUpdates:manager];
        }
    }];
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    [self notify:manager block:^(id<CLLocationManagerDelegate> delegate) {
        if ([delegate respondsToSelector:@selector(locationManagerDidResumeLocationUpdates:)]) {
            [delegate locationManagerDidResumeLocationUpdates:manager];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self notify:manager block:^(id<CLLocationManagerDelegate> delegate) {
        if ([delegate respondsToSelector:@selector(locationManager:didEnterRegion:)]) {
            [delegate locationManager:manager didEnterRegion:region];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self notify:manager block:^(id<CLLocationManagerDelegate> delegate) {
        if ([delegate respondsToSelector:@selector(locationManager:didExitRegion:)]) {
            [delegate locationManager:manager didExitRegion:region];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self notify:manager block:^(id<CLLocationManagerDelegate> delegate) {
        if ([delegate respondsToSelector:@selector(locationManager:didStartMonitoringForRegion:)]) {
            [delegate locationManager:manager didStartMonitoringForRegion:region];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(nullable CLRegion *)region withError:(NSError *)error {
    [self notify:manager block:^(id<CLLocationManagerDelegate> delegate) {
        if ([delegate respondsToSelector:@selector(locationManager:monitoringDidFailForRegion:withError:)]) {
            [delegate locationManager:manager monitoringDidFailForRegion:region withError:error];
        }
    }];
}

@end
