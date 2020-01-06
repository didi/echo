//
//  CLLocationManager+ECHO.m
//  EchoSDK
//
//  Created by zhanghe on 2019/8/22.
//

#import "CLLocationManager+ECHO.h"
#import "ECOMockGPSManager.h"

@implementation CLLocationManager (ECHO)

- (void)echo_setDelegate:(id)delegate {
    [self echo_setDelegate:[ECOMockGPSManager sharedInstance]];
    [[ECOMockGPSManager sharedInstance] addLocationManager:self delegate:delegate];
}

@end
