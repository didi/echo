//
//  defines.h
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#ifndef defines_h
#define defines_h
#import <Cocoa/Cocoa.h>

typedef enum:NSInteger {
    YVWindowDisplayStatusHome,
    YVWindowDisplayStatusInspect,
}YVWindowDisplayStatus;

typedef enum:NSInteger {
    YVSceneViewDisplayModeNone = -1,
    YVSceneViewDisplayModeDeepsFirst,
    YVSceneViewDisplayModeSmart,
    YVSceneViewDisplayModeFlatten,
}YVSceneViewDisplayMode;

static NSString * const YVViewTreeDidLoadNotificationName = @"YVViewTreeDidLoadNotificationName";
static NSString * const YVSelectionChangeMiddleToLeft = @"YVSelectionChangeMiddleToLeft";
static NSString * const YVSelectionChangeLeftToMiddle = @"YVSelectionChangeLeftToMiddle";
static NSString * const YVSelectionChangeLeftToRight = @"YVSelectionChangeLeftToRight";
static NSString * const YVNodeNamePlane = @"YVNodeNamePlane";
static NSString * const YVNodeNameIndicator = @"YVNodeNameIndicator";
static NSString * const YVNodeNameCamera = @"YVNodeNameCamera";
static NSString * const YVNodeNameBorder = @"YVNodeNameBorder";

static NSInteger const YVHitTestOptionCategoryBitMaskPlaneNode = 1<<1;
static NSInteger const YVHitTestOptionCategoryBitMask2SelectedIndicator = 1<<2;
static NSInteger const YVHitTestOptionCategoryBitMask3HoverBorder = 1<<3;

static CGFloat const YVRectDefaultExpandThreshold = 1.0f;


#endif /* defines_h */
