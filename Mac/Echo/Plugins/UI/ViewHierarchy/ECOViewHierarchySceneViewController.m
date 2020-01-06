//
//  ECOViewHierarchySceneViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/19. Maintain by 陈爱彬
//  Description 
//

#import "ECOViewHierarchySceneViewController.h"
#import "ECOSceneView.h"

#import "YVDisplayControl.h"
#import "TravseralContext.h"
#import "YVCGRectHelper.h"
#import "YVNodeBackTracking.h"

#import "SCNNode+YVPlane.h"
#import "SCNNode+YVBorder.h"
#import "SCNNode+YVSelected.h"
#import "SCNNode+YVZIndex.h"
#import "SCNNode+YVIdentifier.h"

//static CGFloat const ECOCameraMaxScale = 11;
//static CGFloat const ECOCameraDefaultScale = 6;
//static CGFloat const ECOCameraMinScale = 1;

@interface ECOViewHierarchySceneViewController ()
<ECOSceneViewDelegate>

@property (nonatomic) NSDictionary * dataSource;
@property (nonatomic) NSDictionary * extrainfo;
@property (nonatomic,strong) YVDisplayControl * displayControl;
@property (nonatomic,strong) SCNNode * cameraNode;

@property (weak) IBOutlet ECOSceneView *sceneView;

@property (nonatomic, assign) BOOL viewDidShown;
@property (nonatomic, strong) NSDictionary *refreshDict;

@end

@implementation ECOViewHierarchySceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.sceneView.delegate = self;
    self.sceneView.wantsLayer = YES;
    self.sceneView.layer.cornerRadius = 20.f;

    self.displayControl = [[YVDisplayControl alloc]init];
}
- (void)viewDidAppear {
    [super viewDidAppear];
    self.viewDidShown = YES;
    if (self.refreshDict) {
        [self refreshViewTreeSceneWithData:self.refreshDict];
        self.refreshDict = nil;
    }
}
- (void)viewWillDisappear {
    [super viewWillDisappear];
    self.viewDidShown = NO;
}
//刷新场景视图
- (void)refreshViewTreeSceneWithData:(NSDictionary *)dict {
    if (self.viewDidShown) {
        [self refreshWhenViewDidShownWithData:dict];
    }else{
        self.refreshDict = dict;
    }
}
- (void)refreshWhenViewDidShownWithData:(NSDictionary *)dict {
    self.dataSource = dict[@"viewtree"];
    self.extrainfo = dict[@"extrainfo"];
    CGRect screenRect = NSRectFromString(self.extrainfo[@"screeninfo"]);
    self.displayControl.screenSize = screenRect.size;
    [self createView];
}
//更新数据信息
- (void)updateNodesInfo:(NSDictionary *)nodesInfo {
    SCNView *scnView = (SCNView *)self.sceneView;
    NSArray * arr = scnView.scene.rootNode.childNodes;
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.5];
    for (SCNNode * each in arr) {
        if ([each.name isEqualToString:YVNodeNamePlane]) {
            NSDictionary *itemInfo = [nodesInfo objectForKey:each.uniqueID];
            if (itemInfo) {
                //修改内容
                NSString *snapshot = itemInfo[@"snapshot"];
                [each updateContent:snapshot];
            }
        }
    }
    [SCNTransaction commit];
}
//左侧列表选中节点后更新选中状态
- (void)listViewDidSelectedNodeUUID:(NSString *)uuid {
    [self.sceneView selectedNode:uuid];
}
//切换显示模式
- (void)changeDisplayMode:(YVSceneViewDisplayMode)newmode {
    self.displayControl.displayMode = newmode;
    [self onDisplayModeChange];
}
- (void)onDisplayModeChange {
    [self reloadScreen];
}
#pragma mark - Scene
- (void)createView {
    SCNScene *scene = [SCNScene sceneNamed:@"empty.scn"];
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.usesOrthographicProjection = YES;
    cameraNode.camera.orthographicScale = 6;
    cameraNode.camera.automaticallyAdjustsZRange = NO;
    cameraNode.camera.zFar = 200.0f;
    self.cameraNode = cameraNode;
    [scene.rootNode addChildNode:cameraNode];
    cameraNode.position = SCNVector3Make(0, 0, 30);
    cameraNode.name = YVNodeNameCamera;
    SCNView *scnView = (SCNView *)self.sceneView;
    scnView.scene = scene;
    scnView.allowsCameraControl = YES;
    scnView.showsStatistics = NO;
    scnView.backgroundColor = [NSColor colorNamed:@"viewScene_bg_color"];
    NSMutableDictionary * levelDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * levelDict1 = [NSMutableDictionary dictionary];
    TravseralContext * context = [[TravseralContext alloc]init];
    [self addNode:self.dataSource deepth:0 levelDict:levelDict levelDictWithoutHiddenObject:levelDict1 context:context];
    [self reloadScreen];
}
- (void)addNode:(NSDictionary*)node deepth:(NSInteger)fatherDepth levelDict:(NSMutableDictionary*)levelDict levelDictWithoutHiddenObject:(NSMutableDictionary*)levelDictWithoutHiddenObject context:(TravseralContext*)context {
//    NSString * uuid = node[@"view_level"];
    NSString * uuid = node[@"address"];
    CGRect windowRect = NSRectFromString(node[@"windowframe"]);
    NSString * snapshot = node[@"snapshot"];
    BOOL isoffscreen = [node[@"isoffscreen"] boolValue];
    BOOL isHidden = [node[@"isHidden"] boolValue];
    CGFloat alpha = [node[@"alpha"] floatValue];
    if (isHidden || alpha == 0) {
        return;
    }
    CGRect transformedRect = [YVCGRectHelper UIKitRectTransformToSceneRect:windowRect withScreenSize:self.displayControl.screenSize];
    [context stepinOffScreen:isoffscreen];
    SCNNode * planeNode = [SCNNode yvplaneWithWidth:transformedRect.size.width*self.displayControl.defaultDisplayFactor height:transformedRect.size.height*self.displayControl.defaultDisplayFactor content:snapshot];
    SCNNode* selectedIndicatorNode = [SCNNode yvselectedNodeWithwidth:transformedRect.size.width*self.displayControl.defaultDisplayFactor height:transformedRect.size.height*self.displayControl.defaultDisplayFactor];
    SCNNode * borderNode = [SCNNode borderNodeWithPlane:planeNode];
    [planeNode addChildNode:selectedIndicatorNode];
    [planeNode addChildNode:borderNode];
    NSInteger bestZ = [YVNodeBackTracking findBestZFromlevelDict:levelDict minDepth:fatherDepth maxDepth:context.objectCounter frame:windowRect];
    NSInteger bestZZ = [YVNodeBackTracking findBestZFromlevelDict:levelDictWithoutHiddenObject minDepth:fatherDepth maxDepth:context.objectCounterWithoutOffScreenObject frame:windowRect];
    planeNode.uniqueID = uuid;
    planeNode.isOffScreen = @(isoffscreen);
    planeNode.hidden = isoffscreen;
    planeNode.position = SCNVector3Make(transformedRect.origin.x*self.displayControl.defaultDisplayFactor, transformedRect.origin.y*self.displayControl.defaultDisplayFactor, 0);
    planeNode.ZSmart = @(bestZ);
    planeNode.ZSmartWihtoutOffScreenItem = @(bestZZ);
    planeNode.ZDeepsFirst = @(context.objectCounter);
    planeNode.ZDeepsFirstWithoutOffScreenItem = @(context.objectCounterWithoutOffScreenObject);
    planeNode.ZFlatten = @(fatherDepth);
    planeNode.ZFlattenWithoutOffScreenItem = @(fatherDepth);
    self.displayControl.maxZSmart = MAX(self.displayControl.maxZSmart, bestZ);
    self.displayControl.maxZSmartOoffScreen = MAX(self.displayControl.maxZSmart, bestZZ);
    self.displayControl.maxZDFS = MAX(self.displayControl.maxZDFS, context.objectCounter);
    self.displayControl.maxZDFSOffScreen = MAX(self.displayControl.maxZDFSOffScreen, context.objectCounterWithoutOffScreenObject);
    self.displayControl.maxZFlatten = MAX(self.displayControl.maxZFlatten, fatherDepth+1);
    self.displayControl.maxZFlattenOffScreen =MAX(self.displayControl.maxZFlattenOffScreen, fatherDepth+1);
    SCNView *scnView = (SCNView *)self.sceneView;
    planeNode.nodeInfo = node;
    [scnView.scene.rootNode addChildNode:planeNode];
    NSArray * sub = node[@"children"];
    for (NSInteger i = 0; i < sub.count; i++) {
        NSDictionary * each = sub[i];
        [self addNode:each deepth:fatherDepth+1 levelDict:levelDict levelDictWithoutHiddenObject:levelDictWithoutHiddenObject  context:context];
    }
}

- (void)resetDisplayScene {
    SCNView *scnView = (SCNView *)self.sceneView;
    [self.cameraNode lookAt:SCNVector3Make(0, 0, 0)];
    self.cameraNode.worldPosition = SCNVector3Make(0, 0, 80);
    self.cameraNode.eulerAngles = SCNVector3Make(0, 0, 0);
    self.cameraNode.camera.orthographicScale = 6;
    scnView.pointOfView = self.cameraNode;
}

- (void)reloadScreen {
    SCNView *scnView = (SCNView *)self.sceneView;
    NSArray * arr = scnView.scene.rootNode.childNodes;
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.5];
    for (SCNNode * each in arr) {
        if ([each.name isEqualToString:YVNodeNamePlane]) {
            [each reloadZ:self.displayControl];
        }
    }
    [SCNTransaction commit];
}

#pragma mark - ECOSceneViewDelegate methods
- (void)sceneView:(SCNView *)scnview didSelectedNode:(SCNNode *)node {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sceneNodeDidSelected:)]) {
        if (node) {
            [self.delegate sceneNodeDidSelected:node.nodeInfo];
        } else {
            [self.delegate sceneNodeDidSelected:nil];
        }
    }
    
}
@end
