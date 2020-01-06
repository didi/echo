//
//  YVDisplayControl.h
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defines.h"

NS_ASSUME_NONNULL_BEGIN

@interface YVDisplayControl : NSObject
@property (nonatomic,assign)YVSceneViewDisplayMode displayMode;
@property (nonatomic,assign)BOOL displayHiddenObject;
@property (nonatomic,assign)CGFloat defaultDisplayFactor;
@property (nonatomic,assign)CGFloat defaultDisplayZFactor;
@property (nonatomic,assign)CGSize screenSize;

@property (nonatomic,assign)NSInteger maxZDFS;
@property (nonatomic,assign)NSInteger maxZDFSOffScreen;
@property (nonatomic,assign)NSInteger maxZFlatten;
@property (nonatomic,assign)NSInteger maxZFlattenOffScreen;
@property (nonatomic,assign)NSInteger maxZSmart;
@property (nonatomic,assign)NSInteger maxZSmartOoffScreen;

@end

NS_ASSUME_NONNULL_END
