//
//  SCNNode+plane.h
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCNNode (YVPlane)
+(SCNNode*)yvplaneWithWidth:(CGFloat)width height:(CGFloat)height content:(id)content;

- (void)updateContent:(id)content;

@end

NS_ASSUME_NONNULL_END
