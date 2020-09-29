//
//  ECOViewHierarchyPlugin.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/19. Maintain by 陈爱彬
//  Description 
//

#import "ECOViewHierarchyPlugin.h"
#import "UIView+YVViewTree.h"
#import "UIView+YVNodeInfo.h"
#import "ECOClient.h"
#import "YVObjectManager.h"

@interface ECOViewHierarchyPlugin()

@end

@implementation ECOViewHierarchyPlugin

+ (void)load {
    [[ECOClient sharedClient] registerPlugin:[self class]];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = @"视图层级";
        [self registerTemplate:@"viewHierarchy" data:nil];
    }
    return self;
}

//连接状态变更
- (void)device:(ECOChannelDeviceInfo *)device didChangedAuthState:(BOOL)isAuthed {
    if (isAuthed) {
        !self.deviceSendBlock ?: self.deviceSendBlock(device, @{@"type": @"connect"});
    }
}

#pragma mark - ECOBasePlugin methods
- (void)didReceivedPacketData:(id)data fromDevice:(ECOChannelDeviceInfo *)device {
//    NSLog(@"接收到CMD数据:%@",data);
    NSDictionary *query = (NSDictionary *)data;
    NSString *cmd = query[@"cmd"];
    if ([cmd isEqualToString:@"viewtree"]) {
        //获取视图层级
        __block NSDictionary * viewtree;
        dispatch_async(dispatch_get_main_queue(), ^{
            viewtree = [UIView rootViewTreeDictionary];
            !self.deviceSendBlock ?: self.deviceSendBlock(device, @{@"type": @"viewtree", @"data": viewtree});
        });
    }else if ([cmd isEqualToString:@"edit"]){
        NSString *address = query[@"address"];
        NSString *selString = query[@"sel"];
        id argv = query[@"argv"];
        NSMapTable *maptable = [YVObjectManager sharedInstance].context.viewMap;
        UIView *v = [maptable objectForKey:address];
        if (!v || ![v isKindOfClass:[UIView class]]) {
            return;
        }
        NSMutableDictionary *extraDict = [NSMutableDictionary dictionary];
        if ([selString isEqualToString:@"hidden"]) {
            if ([v respondsToSelector:@selector(setHidden:)]) {
                BOOL isHidden = [argv boolValue];
                [v setHidden:isHidden];
                [extraDict setObject:@{@"isHidden": argv} forKey:address];
            }
        }else if ([selString isEqualToString:@"userInteraction"]) {
            if ([v respondsToSelector:@selector(setUserInteractionEnabled:)]) {
                BOOL isEnable = [argv boolValue];
                [v setUserInteractionEnabled:isEnable];
                [extraDict setObject:@{@"userInter": argv} forKey:address];
            }
        }else if ([selString isEqualToString:@"maskToBounds"]) {
            if ([v.layer respondsToSelector:@selector(setMasksToBounds:)]) {
                BOOL isEnable = [argv boolValue];
                [v.layer setMasksToBounds:isEnable];
                [extraDict setObject:@{@"masksTB": argv} forKey:address];
            }
        }else if ([selString isEqualToString:@"bgColor"]) {
            if ([v respondsToSelector:@selector(setBackgroundColor:)]) {
                NSString *color = (NSString *)argv;
                UIColor *bgColor = [self colorFromString:color];
                [v setBackgroundColor:bgColor];
                NSString *colorString = [v _ecoColorRGBA:bgColor];
                [extraDict setObject:@{@"bgColor": colorString} forKey:address];
            }
        }else if ([selString isEqualToString:@"borderColor"]) {
            if ([v.layer respondsToSelector:@selector(setBorderColor:)]) {
                NSString *color = (NSString *)argv;
                UIColor *borderColor = [self colorFromString:color];
                [v.layer setBorderColor:borderColor.CGColor];
                NSString *colorString = [v _ecoColorRGBA:borderColor];
                [extraDict setObject:@{@"bdColor": colorString} forKey:address];
            }
        }else if ([selString isEqualToString:@"shadowColor"]) {
            if ([v.layer respondsToSelector:@selector(setShadowColor:)]) {
                NSString *color = (NSString *)argv;
                UIColor *shadowColor = [self colorFromString:color];
                [v.layer setShadowColor:shadowColor.CGColor];
                NSString *colorString = [v _ecoColorRGBA:shadowColor];
                [extraDict setObject:@{@"sColor": colorString} forKey:address];
            }
        }else if ([selString isEqualToString:@"alpha"]) {
            if ([v respondsToSelector:@selector(setAlpha:)]) {
                CGFloat alpha = [argv floatValue];
                [v setAlpha:alpha];
                [extraDict setObject:@{@"alpha": argv} forKey:address];
            }
        }else if ([selString isEqualToString:@"borderWidth"]) {
            if ([v.layer respondsToSelector:@selector(setBorderWidth:)]) {
                CGFloat borderWidth = [argv floatValue];
                [v.layer setBorderWidth:borderWidth];
                [extraDict setObject:@{@"bdWidth": argv} forKey:address];
            }
        }else if ([selString isEqualToString:@"cornerRadius"]) {
            if ([v.layer respondsToSelector:@selector(setCornerRadius:)]) {
                CGFloat cornerRadius = [argv floatValue];
                [v.layer setCornerRadius:cornerRadius];
                [extraDict setObject:@{@"radius": argv} forKey:address];
            }
        }else if ([selString isEqualToString:@"shadowOpacity"]) {
            if ([v.layer respondsToSelector:@selector(setShadowOpacity:)]) {
                CGFloat shadowOpacity = [argv floatValue];
                [v.layer setShadowOpacity:shadowOpacity];
                [extraDict setObject:@{@"sOpacity": argv} forKey:address];
            }
        }else if ([selString isEqualToString:@"shadowRadius"]) {
            if ([v.layer respondsToSelector:@selector(setShadowRadius:)]) {
                CGFloat shadowRadius = [argv floatValue];
                [v.layer setShadowRadius:shadowRadius];
                [extraDict setObject:@{@"sRadius": argv} forKey:address];
            }
        }else if ([selString isEqualToString:@"shadowOffsetW"]) {
            if ([v.layer respondsToSelector:@selector(setShadowOffset:)]) {
                CGFloat offsetW = [argv floatValue];
                CGSize shadowOffset = v.layer.shadowOffset;
                [v.layer setShadowOffset:CGSizeMake(offsetW, shadowOffset.height)];
                [extraDict setObject:@{@"sOffW": argv} forKey:address];
            }
        }else if ([selString isEqualToString:@"shadowOffsetH"]) {
            if ([v.layer respondsToSelector:@selector(setShadowOffset:)]) {
                CGFloat offsetH = [argv floatValue];
                CGSize shadowOffset = v.layer.shadowOffset;
                [v.layer setShadowOffset:CGSizeMake(shadowOffset.width, offsetH)];
                [extraDict setObject:@{@"sOffH": argv} forKey:address];
            }
        }else if ([selString isEqualToString:@"localframe"]) {
            if ([v respondsToSelector:@selector(setFrame:)]) {
                NSString *frameStr = (NSString *)argv;
                CGRect frame = CGRectFromString(frameStr);
                [v setFrame:frame];
                [extraDict setObject:@{@"localframe": argv} forKey:address];
            }
        }
        [v setNeedsDisplay];
        [v layoutIfNeeded];
        
        //传递新的信息到mac端
        NSDictionary *updateInfo = [v ecoUpdateInfo];
        !self.deviceSendBlock ?: self.deviceSendBlock(device, @{@"type": @"update", @"data": updateInfo, @"extra": extraDict});
    }
}

#pragma mark - helper
- (UIColor *)colorFromString:(NSString *)color {
    if (color.length) {
        NSArray *components = [color componentsSeparatedByString:@","];
        CGFloat R = [components[0] floatValue];
        CGFloat G = [components[1] floatValue];
        CGFloat B = [components[2] floatValue];
        CGFloat alpha = 1.f;
        if (components.count == 4) {
            alpha = [components[4] floatValue];
        }
        return [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:alpha];
    }
    return nil;
}
@end
