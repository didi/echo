//
//  SCNNode+border.h
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCNNode (YVBorder)
+(SCNNode*)borderNodeWithPlane:(SCNNode*)plane;
@end

NS_ASSUME_NONNULL_END
