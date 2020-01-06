//
//  SCNNode+plane.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "SCNNode+YVPlane.h"
#import "defines.h"
#import "SCNNode+YVVisual.h"

@implementation SCNNode (YVPlane)
+(SCNNode*)yvplaneWithWidth:(CGFloat)width height:(CGFloat)height content:(id)content
{
    SCNPlane *plane =[SCNPlane planeWithWidth:width height:height];
    NSString * snapshot = content;
    NSImage *image;
    if (snapshot && snapshot.length > 0) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:snapshot options:NSDataBase64DecodingIgnoreUnknownCharacters];
        image =[[NSImage alloc]initWithData:imageData];
    }
    if (image) {
        plane.firstMaterial.diffuse.contents = image;
    }else{
        plane.firstMaterial.diffuse.contents = [NSColor clearColor];
    }
    plane.firstMaterial.doubleSided = YES;
//    plane.firstMaterial.writesToDepthBuffer = NO;
//    plane.firstMaterial.readsFromDepthBuffer = NO;
    SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
    planeNode.categoryBitMask = YVHitTestOptionCategoryBitMaskPlaneNode;
    planeNode.name = YVNodeNamePlane;
    return planeNode;
}

- (void)updateContent:(id)content {
    SCNPlane *plane = (SCNPlane *)self.geometry;
    NSString * snapshot = content;
    NSImage *image;
    if (snapshot && snapshot.length > 0) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:snapshot options:NSDataBase64DecodingIgnoreUnknownCharacters];
        image =[[NSImage alloc]initWithData:imageData];
    }
    if (image) {
        plane.firstMaterial.diffuse.contents = image;
        [self showBorder];
    }else{
        plane.firstMaterial.diffuse.contents = [NSColor clearColor];
        [self hideBorder];
    }
}
@end
