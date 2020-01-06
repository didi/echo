//
//  SCNNode+YVVisual.m
//  YourView
//
//  Created by bliss_ddo on 2019/5/5.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "SCNNode+YVVisual.h"
#import "defines.h"

@implementation SCNNode (YVVisual)
-(void)hover
{
    SCNNode * borderChild = [self childNodeWithName:YVNodeNameBorder recursively:YES];
    if (borderChild) {
        borderChild.geometry.firstMaterial.diffuse.contents = [NSColor colorWithRed:80/255.f green:131/255.f blue:219/255.f alpha:1.f];
    }
}
-(void)unhover
{
    SCNNode * borderChild = [self childNodeWithName:YVNodeNameBorder recursively:YES];
    if (borderChild) {
        borderChild.geometry.firstMaterial.diffuse.contents = [NSColor colorWithRed:218/255.f green:218/255.f blue:218/255.f alpha:1.f];
    }
}
- (void)hideBorder {
    SCNNode * borderChild = [self childNodeWithName:YVNodeNameBorder recursively:YES];
    if (borderChild) {
        borderChild.hidden = YES;
    }
}
- (void)showBorder {
    SCNNode * borderChild = [self childNodeWithName:YVNodeNameBorder recursively:YES];
    if (borderChild) {
        borderChild.hidden = NO;
    }
}


-(void)highlight
{
    SCNNode * indicator = [self childNodeWithName:YVNodeNameIndicator recursively:YES];
    if (indicator) {
        indicator.hidden = NO;
    }
}
-(void)lowlight
{
    SCNNode * indicator = [self childNodeWithName:YVNodeNameIndicator recursively:YES];
    if (indicator) {
        indicator.hidden = YES;
    }
}
@end
