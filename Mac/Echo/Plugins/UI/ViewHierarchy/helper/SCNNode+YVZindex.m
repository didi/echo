//
//  SCNNode+zstorage.m
//  revealY
//
//  Created by bliss_ddo on 2019/4/23.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "SCNNode+YVZIndex.h"
#import <objc/runtime.h>

@implementation SCNNode (zstorage)

//-(void)reloadZ:(CGFloat)zValue
//{
//    CGFloat zfactor = 0.3;
//    NSInteger zmiddle = 0;
//    NSInteger zindex = 0;
//    zindex = self.ZSmartWihtoutOffScreenItem.integerValue;
//    zmiddle = 0;
//
//    self.hidden = ([self.isOffScreen boolValue] && !shouldDisplayOffScreenItem);
//    if (displayMode == YVSceneViewDisplayModeDeepsFirst) {
//        zindex = shouldDisplayOffScreenItem?self.ZDeepsFirst.integerValue:self.ZDeepsFirstWithoutOffScreenItem.integerValue;
//        zmiddle = shouldDisplayOffScreenItem? displayControl.maxZDFS : displayControl.maxZDFSOffScreen;
//    }else if (displayMode == YVSceneViewDisplayModeFlatten){
//        zindex = shouldDisplayOffScreenItem ? self.ZFlatten.integerValue:self.ZFlattenWithoutOffScreenItem.integerValue;
//        zmiddle = shouldDisplayOffScreenItem ? displayControl.maxZFlatten : displayControl.maxZFlattenOffScreen;
//        //        NSLog(@"%ld %ld %ld",zindex,zmiddle,(zindex - zmiddle/2));
//    }else if (displayMode == YVSceneViewDisplayModeSmart){
//        zindex = shouldDisplayOffScreenItem ? self.ZSmart.integerValue : self.ZSmartWihtoutOffScreenItem.integerValue;
//        zmiddle = shouldDisplayOffScreenItem ? displayControl.maxZSmart: displayControl.maxZSmartOoffScreen;
//    }
//    zindex = zindex - zmiddle/2;
//    SCNVector3 v3 = self.position;
//    self.eulerAngles = SCNVector3Make(0, 0, 0);
//    self.position = SCNVector3Make(v3.x, v3.y, zindex*zfactor);
//}
-(void)reloadZ:(YVDisplayControl*)displayControl
{
    BOOL shouldDisplayOffScreenItem = displayControl.displayHiddenObject;
    YVSceneViewDisplayMode displayMode = displayControl.displayMode;
    CGFloat zfactor = displayControl.defaultDisplayZFactor;
    NSInteger zmiddle = 0;
    NSInteger zindex = 0;
    self.hidden = ([self.isOffScreen boolValue] && !shouldDisplayOffScreenItem);
    if (displayMode == YVSceneViewDisplayModeDeepsFirst) {
        zindex = shouldDisplayOffScreenItem?self.ZDeepsFirst.integerValue:self.ZDeepsFirstWithoutOffScreenItem.integerValue;
        zmiddle = shouldDisplayOffScreenItem? displayControl.maxZDFS : displayControl.maxZDFSOffScreen;
    }else if (displayMode == YVSceneViewDisplayModeFlatten){
        zindex = shouldDisplayOffScreenItem ? self.ZFlatten.integerValue:self.ZFlattenWithoutOffScreenItem.integerValue;
        zmiddle = shouldDisplayOffScreenItem ? displayControl.maxZFlatten : displayControl.maxZFlattenOffScreen;
//        NSLog(@"%ld %ld %ld",zindex,zmiddle,(zindex - zmiddle/2));
    }else if (displayMode == YVSceneViewDisplayModeSmart){
        zindex = shouldDisplayOffScreenItem ? self.ZSmart.integerValue : self.ZSmartWihtoutOffScreenItem.integerValue;
        zmiddle = shouldDisplayOffScreenItem ? displayControl.maxZSmart: displayControl.maxZSmartOoffScreen;
    }
    zindex = zindex - zmiddle/2;
    SCNVector3 v3 = self.position;
    self.eulerAngles = SCNVector3Make(0, 0, 0);
    self.position = SCNVector3Make(v3.x, v3.y, zindex*zfactor);
}
-(NSNumber *)ZSmart
{
    return objc_getAssociatedObject(self, "ZSmart");
}
-(void)setZSmart:(NSNumber *)ZSmart
{
    objc_setAssociatedObject(self, "ZSmart", ZSmart, OBJC_ASSOCIATION_RETAIN);
}
- (NSNumber *)ZSmartWihtoutOffScreenItem
{
    return objc_getAssociatedObject(self, "ZSmartWihtoutOffScreenItem");
}
-(void)setZSmartWihtoutOffScreenItem:(NSNumber *)ZSmartWihtoutOffScreenItem
{
    objc_setAssociatedObject(self, "ZSmartWihtoutOffScreenItem", ZSmartWihtoutOffScreenItem, OBJC_ASSOCIATION_RETAIN);
}
- (NSNumber *)ZDeepsFirst
{
    return objc_getAssociatedObject(self, "ZDeepsFirst");
}
-(void)setZDeepsFirst:(NSNumber *)ZDeepsFirst
{
    objc_setAssociatedObject(self, "ZDeepsFirst", ZDeepsFirst, OBJC_ASSOCIATION_RETAIN);
}
-(NSNumber *)ZDeepsFirstWithoutOffScreenItem
{
    return objc_getAssociatedObject(self, "ZDeepsFirstWithoutOffScreenItem");
}
-(void)setZDeepsFirstWithoutOffScreenItem:(NSNumber *)ZDeepsFirstWithoutOffScreenItem
{
    objc_setAssociatedObject(self, "ZDeepsFirstWithoutOffScreenItem", ZDeepsFirstWithoutOffScreenItem, OBJC_ASSOCIATION_RETAIN);
}
- (NSNumber *)ZFlatten
{
    return objc_getAssociatedObject(self, "ZFlatten");
}
-(void)setZFlatten:(NSNumber *)ZFlatten
{
    objc_setAssociatedObject(self, "ZFlatten", ZFlatten, OBJC_ASSOCIATION_RETAIN);
}
-(NSNumber *)ZFlattenWithoutOffScreenItem
{
    return objc_getAssociatedObject(self, "ZFlattenWithoutOffScreenItem");
}
-(void)setZFlattenWithoutOffScreenItem:(NSNumber *)ZFlattenWithoutOffScreenItem
{
    objc_setAssociatedObject(self, "ZFlattenWithoutOffScreenItem", ZFlattenWithoutOffScreenItem, OBJC_ASSOCIATION_RETAIN);
}
-(NSNumber *)isOffScreen
{
    return objc_getAssociatedObject(self, "isOffScreen");
}
-(void)setIsOffScreen:(NSNumber *)isOffScreen
{
    objc_setAssociatedObject(self, "isOffScreen", isOffScreen, OBJC_ASSOCIATION_RETAIN );
}

-(NSDictionary *)nodeInfo
{
    return objc_getAssociatedObject(self, "nodeInfo");
}
-(void)setNodeInfo:(NSDictionary *)nodeInfo
{
    objc_setAssociatedObject(self, "nodeInfo", nodeInfo, OBJC_ASSOCIATION_RETAIN );
}
@end
