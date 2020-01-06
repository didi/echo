//
//  SCNNode+YVIdentifier.m
//  YourView
//
//  Created by bliss_ddo on 2019/5/5.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "SCNNode+YVIdentifier.h"
#import <objc/runtime.h>

@implementation SCNNode (YVIdentifier)
-(void)setUniqueID:(NSString *)uniqueID
{
    objc_setAssociatedObject(self, "UniqueID", uniqueID, OBJC_ASSOCIATION_RETAIN);
}
-(NSString *)uniqueID
{
    return objc_getAssociatedObject(self, "UniqueID");
}

@end
