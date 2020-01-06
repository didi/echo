//
//  NSObject+YVNodeInfo.m
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "NSObject+YVNodeInfo.h"

@implementation NSObject (YVNodeInfo)
-(NSDictionary*)nodeInfo
{
    NSString * _class = [self _class];
    NSString * _address = [self _address];
    NSString * _inherit = [self _inherit];

    return @{
             @"class":_class,
             @"address":_address,
             @"inherit":_inherit,
             };
}

-(NSString*)_class
{
    return NSStringFromClass(self.class);
}

-(NSString*)_inherit
{
    NSString * inherit = @"";
    Class c = self.class;
    while (c) {
        inherit = [NSString stringWithFormat:@"%@ : %@",inherit,NSStringFromClass(c.class)];
        c = c.superclass;
    }
    return [inherit substringFromIndex:3];
}

-(NSString*)_address
{
    return [NSString stringWithFormat:@"%p",self];
}
-(NSString*)ecoNodeAddress {
    return [self _address];
}
@end
