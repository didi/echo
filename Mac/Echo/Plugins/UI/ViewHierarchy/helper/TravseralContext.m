//
//  TravseralContext.m
//  revealY
//
//  Created by bliss_ddo on 2019/4/22.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "TravseralContext.h"

@implementation TravseralContext
-(instancetype)init
{
    if (self = [super init]) {
        _objectCounter = -1;
        _objectCounterWithoutOffScreenObject = -1;
    }
    return self;
}
-(void)stepin
{
    _objectCounter++;
}
-(void)stepinOffScreen:(BOOL)isoffScreen
{
    _objectCounter++;
    if (!isoffScreen) {
        _objectCounterWithoutOffScreenObject++;
    }
}
@end
