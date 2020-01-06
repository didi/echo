//
//  SCNNode+selected.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "SCNNode+YVSelected.h"
#import "defines.h"

@implementation SCNNode (YVSelected)
+(SCNNode*)yvselectedNodeWithwidth:(CGFloat)width height:(CGFloat)height
{
    SCNPlane *planeMirror =[SCNPlane planeWithWidth:width height:height];
    planeMirror.firstMaterial.diffuse.contents = [NSColor colorWithRed:206/255.f green:214/255.f blue:255/255.f alpha:1.f];
    planeMirror.firstMaterial.doubleSided = YES;
//    planeMirror.firstMaterial.writesToDepthBuffer = NO;
//    planeMirror.firstMaterial.readsFromDepthBuffer = NO;
    SCNNode *planeMirrorNode = [SCNNode nodeWithGeometry:planeMirror];
    planeMirrorNode.opacity = 0.8;
    planeMirrorNode.hidden = YES;
    planeMirrorNode.categoryBitMask = YVHitTestOptionCategoryBitMask2SelectedIndicator;
    planeMirrorNode.name = YVNodeNameIndicator;

    return planeMirrorNode;
}
@end
