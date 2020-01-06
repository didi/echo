//
//  SCNNode+YVVisual.h
//  YourView
//
//  Created by bliss_ddo on 2019/5/5.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCNNode (YVVisual)

-(void)hover;
-(void)unhover;

- (void)hideBorder;
- (void)showBorder;

-(void)highlight;
-(void)lowlight;

@end

NS_ASSUME_NONNULL_END
