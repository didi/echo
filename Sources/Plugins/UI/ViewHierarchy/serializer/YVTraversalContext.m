//
//  YVTraversalContext.m
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVTraversalContext.h"



@implementation YVTraversalContext
@synthesize objectCounter = _objectCounter;
@synthesize hidenObjectCounter = _hidenObjectCounter;
@synthesize notHidenObjectCounter = _notHidenObjectCounter;

-(instancetype)init
{
    if (self = [super init]) {
        _objectCounter = 0;
        _hidenObjectCounter = 0;
        _notHidenObjectCounter = 0;
        _viewMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableWeakMemory];
    }
    return self;
}

-(NSInteger)objectCounter
{
    return _objectCounter;
}

-(NSInteger)hidenObjectCounter
{
    return _hidenObjectCounter;
}

-(NSInteger)notHidenObjectCounter
{
    return _notHidenObjectCounter;
}

-(void)updateFromView:(UIView*)v
{
    _objectCounter++;
    if (v.hidden) {
        _hidenObjectCounter++;
    }else{
        _notHidenObjectCounter++;
    }
    NSString * memoryKey = [NSString stringWithFormat:@"%p",v];
    [self.viewMap setObject:v forKey:memoryKey];
}

-(NSDictionary *)contextDict
{
    
    return @{
             @"screeninfo":NSStringFromCGRect([UIScreen mainScreen].bounds),
             @"totalcount":@(_objectCounter),
             };
}

@end
