//
//  YVTraversalContext.h
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVTraversalContext : NSObject
-(void)updateFromView:(UIView*)v;
@property (nonatomic,assign,readonly) NSInteger objectCounter ;
@property (nonatomic,assign,readonly) NSInteger hidenObjectCounter;
@property (nonatomic,assign,readonly) NSInteger notHidenObjectCounter;
@property (nonatomic,strong,readonly) NSDictionary * contextDict;
@property (nonatomic,strong,readonly) NSMapTable * viewMap;
@end

NS_ASSUME_NONNULL_END
