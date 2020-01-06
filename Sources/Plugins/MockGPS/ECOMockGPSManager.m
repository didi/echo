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

#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self notifyLocations:locations];
}

@end
