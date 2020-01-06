//
//  AppDelegate.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/15. Maintain by 陈爱彬
//  Description 
//

#import "AppDelegate.h"
#import <EchoSDK/ECOCoreManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    //启动服务
    [[ECOCoreManager shared] start];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    for (NSWindow *w in sender.windows) {
        [w makeKeyAndOrderFront:nil];
    }
    return YES;
}

@end
