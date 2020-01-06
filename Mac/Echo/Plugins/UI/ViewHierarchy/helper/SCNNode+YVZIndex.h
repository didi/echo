//
//  SCNNode+zstorage.h
//  revealY
//
//  Created by bliss_ddo on 2019/4/23.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "YVDisplayControl.h"
NS_ASSUME_NONNULL_BEGIN

@interface SCNNode (YVZindex)
-(void)reloadZ:(YVDisplayControl*)displayControl;
@property (nonatomic,strong) NSNumber * ZSmart;
@property (nonatomic,strong) NSNumber * ZSmartWihtoutOffScreenItem;
@property (nonatomic,strong) NSNumber * ZDeepsFirst;
@property (nonatomic,strong) NSNumber * ZDeepsFirstWithoutOffScreenItem;
@property (nonatomic,strong) NSNumber * ZFlatten;
@property (nonatomic,strong) NSNumber * ZFlattenWithoutOffScreenItem;
@property (nonatomic,strong) NSNumber * isOffScreen;

@property (nonatomic,strong) NSDictionary *nodeInfo;

@end

NS_ASSUME_NONNULL_END
