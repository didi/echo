//
//  YVObjectManager.m
//  libyourview
//
//  Created by bliss_ddo on 2019/5/5.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVObjectManager.h"

@implementation YVObjectManager
static YVObjectManager * _signleton;
+(YVObjectManager *)sharedInstance
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _signleton = [[YVObjectManager alloc]init];
    });
    return _signleton;
}
@end
