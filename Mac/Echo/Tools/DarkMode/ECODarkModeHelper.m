//
//  ECODarkModeHelper.m
//  Echo
//
//  Created by 陈爱彬 on 2019/7/12. Maintain by 陈爱彬
//  Description 
//

#import "ECODarkModeHelper.h"
#import <AppKit/AppKit.h>

static NSString *const kECODarkModeChangedNotification = @"AppleInterfaceThemeChangedNotification";

@interface ECODarkModeHelper()

@property (nonatomic, strong) NSMapTable *subscriberMapTable;
@property (nonatomic, assign) BOOL previousMode;
@end

@implementation ECODarkModeHelper

#pragma mark - LifeCycle Methods
- (void)dealloc {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)shared {
    static ECODarkModeHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [ECODarkModeHelper new];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.previousMode = [self isDarkMode];
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(darkModeChanged:) name:kECODarkModeChangedNotification object:nil];
    }
    return self;
}

#pragma mark - Subscribe Methods
- (void)subscribeDarkModeChangedEvent:(id)obj
                              handler:(void(^)(BOOL isDarkMode))eventHandler
                          immediately:(BOOL)flag {
    if ([self.subscriberMapTable objectForKey:obj] != nil) {
        //已经注册过
        return;
    }
    if (!eventHandler) {
        //无block，不处理
        return;
    }
    dispatch_block_t block = [eventHandler copy];
    [self.subscriberMapTable setObject:block forKey:obj];
    
    if (flag) {
        BOOL isDarkMode = [self isDarkMode];
        eventHandler(isDarkMode);
    }
}
- (void)unsubscribeDarkModeChangedEvent:(id)obj {
    if ([self.subscriberMapTable objectForKey:obj] == nil) {
        return;
    }
    [self.subscriberMapTable removeObjectForKey:obj];
}
#pragma mark - DarkMode Methods
- (void)darkModeChanged:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isDarkMode = [self isDarkMode];
        if (self.previousMode == isDarkMode) {
            return;
        }
        self.previousMode = isDarkMode;
        NSEnumerator *handlers = [self.subscriberMapTable objectEnumerator];
        for (void(^block)(BOOL) in handlers.allObjects) {
            !block ?: block(isDarkMode);
        }
    });
}

- (BOOL)isDarkMode {
    if (@available(macOS 10.14, *)) {
        NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
        NSAppearance *appearance = window.effectiveAppearance;
        NSAppearanceName matchName = [appearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua, NSAppearanceNameAqua]];
        if (matchName == NSAppearanceNameDarkAqua) {
            return YES;
        }
    }
    return NO;
}

- (NSMapTable *)subscriberMapTable {
    if (!_subscriberMapTable) {
        _subscriberMapTable = [NSMapTable weakToStrongObjectsMapTable];
    }
    return _subscriberMapTable;
}
@end
