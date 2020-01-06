//
//  TravseralContext.h
//  revealY
//
//  Created by bliss_ddo on 2019/4/22.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TravseralContext : NSObject
@property (nonatomic,assign,readonly) NSInteger objectCounter;
@property (nonatomic,assign,readonly) NSInteger objectCounterWithoutOffScreenObject;
-(void)stepin;
-(void)stepinOffScreen:(BOOL)isoffScreen;
@end

NS_ASSUME_NONNULL_END
