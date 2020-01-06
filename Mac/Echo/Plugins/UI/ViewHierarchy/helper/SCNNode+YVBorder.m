//
//  SCNNode+border.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "SCNNode+YVBorder.h"
#import "defines.h"

@implementation SCNNode (YVBorder)
+(SCNNode*)borderNodeWithPlane:(SCNNode*)planeNode
{
    SCNVector3 max,min;
    [planeNode getBoundingBoxMin:&min max:&max];
    CGFloat xx = max.x - min.x;
    CGFloat yy = max.y - min.y;
    SCNVector3 vec[] =
    {
        max,
        SCNVector3Make(max.x, max.y-yy, max.z),
        SCNVector3Make(max.x-xx, max.y-yy, max.z),
        SCNVector3Make(max.x-xx, max.y, max.z),
    };
    GLubyte indexs[] ={
        0,1,1,2,2,3,3,0
    };
    SCNGeometrySource * vecSource = [SCNGeometrySource geometrySourceWithVertices:vec count:4];
    NSData * indexData = [NSData dataWithBytes:indexs length:8];
    SCNGeometryElement * indexElement = [SCNGeometryElement geometryElementWithData:indexData primitiveType:SCNGeometryPrimitiveTypeLine primitiveCount:4 bytesPerIndex:sizeof(GLubyte)];
    SCNGeometry * geometry = [SCNGeometry geometryWithSources:@[vecSource] elements:@[indexElement]];
    geometry.firstMaterial.diffuse.contents = [NSColor colorWithRed:215.f/255.f green:215.f/255.f blue:215.f/255.f alpha:1];
    geometry.firstMaterial.doubleSided = YES;
    SCNNode * borderNode = [SCNNode nodeWithGeometry:geometry];
    borderNode.name = YVNodeNameBorder;
    borderNode.categoryBitMask = YVHitTestOptionCategoryBitMask3HoverBorder;
    return borderNode;
}
@end
