//
//  YVDisplayControl.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVDisplayControl.h"

@implementation YVDisplayControl
-(instancetype)init
{
    if (self = [super init]) {
        _displayMode = YVSceneViewDisplayModeSmart;
        _displayHiddenObject = NO;
        _defaultDisplayFactor = 0.01;
        _defaultDisplayZFactor = 0.3;
        _maxZDFS = 0;
        _maxZDFSOffScreen = 0;
        _maxZFlatten = 0;
        _maxZFlattenOffScreen = 0;
        _maxZSmart = 0;
        _maxZSmartOoffScreen = 0;
        
    }
    return self;
}
@end
