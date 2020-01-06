//
//  ECONSUserDefaultsPlugin.h
//  Echo
//
//  Created by 陈爱彬 on 2019/6/21. Maintain by 陈爱彬
//  Description 
//

#import "ECOBasePlugin.h"

/*!
 NSUserDefaultsPlugin 插件
 可接受的命令为：
 1、修改数据：
    @{
        @"cmd" : @"set",
        @"info" : @{
            @"key" : @"key",
            @"value" : value
        }
     }

 2、删除数据：
    @{
        @"cmd" : @"del",
        @"info" : @{
            @"key" : @"key",
        }
    }

 3、更新数据
    @{
        @"cmd" : @"refresh"
    }
 */
NS_ASSUME_NONNULL_BEGIN
@interface ECONSUserDefaultsPlugin : ECOBasePlugin
@end
NS_ASSUME_NONNULL_END
