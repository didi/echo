//
//  ECOViewBorderInspector.m
//  EchoSDK
//
//  Created by zhanghe on 2019/8/28.
//

#import "ECOViewBorderInspector.h"
#import "UIView+ECOViewBorder.h"
#import "ECOSwizzle.h"

@implementation ECOViewBorderInspector

+ (instancetype)sharedInstance {
    static ECOViewBorderInspector *instance = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[ECOViewBorderInspector alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setShowViewBorder:(BOOL)showViewBorder {
    if (_showViewBorder != showViewBorder) {
        _showViewBorder = showViewBorder;
        [[NSNotificationCenter defaultCenter] postNotificationName:ECHOToggleViewBorderNotification object:nil];
    }
}



@end
