//
//  ECOSceneView.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/19. Maintain by 陈爱彬
//  Description 
//

#import "ECOSceneView.h"
#import "SCNNode+YVVisual.h"
#import "SCNNode+YVZindex.h"
#import "SCNNode+YVIdentifier.h"
#import "defines.h"

@interface ECOSceneView()

@property (nonatomic,strong) NSTrackingArea * trackingArea;
@property (nonatomic,strong) SCNNode * hoverNode;
@property (nonatomic,strong) SCNNode * selectedNode;

@end

@implementation ECOSceneView

@synthesize delegate = _delegate;

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [NSColor blackColor];
    if (self.trackingArea == nil) {
        [self createTrackingArea];
        self.hoverNode = nil;
    }
    NSClickGestureRecognizer *clickGesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(onMouseClick:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:clickGesture];
    [gestureRecognizers addObjectsFromArray:self.gestureRecognizers];
    self.gestureRecognizers = gestureRecognizers;
}

-(void)createTrackingArea
{
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                                options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow )
                                                                  owner:self
                                                               userInfo:nil];
    self.trackingArea = trackingArea;
    [self addTrackingArea:trackingArea];
}

- (void)updateTrackingAreas
{
    [self removeTrackingArea:self.trackingArea];
    self.trackingArea = nil;
    [self createTrackingArea];
    [super updateTrackingAreas];
}


#pragma mark MouseEvent

- (void)onMouseClick:(NSGestureRecognizer *)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self];
    NSArray *hitResults = [self hitTest:p options:@{SCNHitTestOptionCategoryBitMask:[NSNumber numberWithInteger:
                                                                                     (YVHitTestOptionCategoryBitMaskPlaneNode)],SCNHitTestIgnoreHiddenNodesKey:@(YES)}];
    if ([hitResults count] > 0) {
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        SCNNode * hitNode = result.node;
        if (self.selectedNode != hitNode) {
            [self.selectedNode lowlight];
            [hitNode highlight];
            self.selectedNode = hitNode;
        }
    }else{
        [self.selectedNode lowlight];
        self.selectedNode = nil;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sceneView:didSelectedNode:)]) {
        [self.delegate sceneView:self didSelectedNode:self.selectedNode];
    }
}



-(void)onMouseMoved:(NSEvent*)theEvent
{
    NSPoint p = theEvent.locationInWindow;
    NSPoint converted = [self convertPoint:p fromView:nil];
    NSArray *hitResults = [self hitTest:converted options:@{SCNHitTestOptionCategoryBitMask:[NSNumber numberWithInteger:
                                                                                             (YVHitTestOptionCategoryBitMaskPlaneNode)],SCNHitTestIgnoreHiddenNodesKey:@(YES)}];
    if ([hitResults count] > 0) {
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        SCNNode * hitNode = result.node;
        if (hitNode != self.hoverNode){
            [self.hoverNode unhover];
            [hitNode hover];
            self.hoverNode = hitNode;
        }
    }
    else{
        [self.hoverNode unhover];
        self.hoverNode = nil;
    }
}

-(void)mouseMoved:(NSEvent *)theEvent
{
    [super mouseMoved:theEvent];
    [self onMouseMoved:theEvent];
}

-(void)selectedNode:(NSString*)uuid
{
    __weak typeof(self) weakSelf = self;
    [self.scene.rootNode childNodesPassingTest:^BOOL(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([child.name isEqualToString:YVNodeNamePlane]) {
            if ([child.uniqueID isEqualToString:uuid]) {
                if (child != strongSelf.selectedNode){
                    [strongSelf.selectedNode lowlight];
                    [child highlight];
                    strongSelf.selectedNode = child;
                }
                *stop = YES;
            }
        }
        return YES;
    }];
}

@end
