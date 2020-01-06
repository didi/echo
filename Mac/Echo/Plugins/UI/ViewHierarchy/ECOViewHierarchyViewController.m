//
//  ECOViewHierarchyViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/19. Maintain by 陈爱彬
//  Description 
//

#import "ECOViewHierarchyViewController.h"
#import "ECOViewHierarchyListViewController.h"
#import "ECOViewHierarchySceneViewController.h"
#import "ECOViewHierarchyInfoViewController.h"
#import <Masonry/Masonry.h>
#import "defines.h"
#import <Quartz/Quartz.h>

@interface ECOViewHierarchyViewController ()
<ECOViewHierarchyListSelectionDelegate,
ECOViewHierarchySceneSelectionDelegate,
ECOViewHierarchyInfoEditDelegate>

@property (weak) IBOutlet NSBox *headerBox;
@property (weak) IBOutlet NSButton *refreshBtn;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSSplitView *splitView;

@property (nonatomic,assign) BOOL firstLoad;
@property (nonatomic,assign) BOOL isLeftSelected;
@property (nonatomic,assign) BOOL isRightSelected;
@property (nonatomic,assign) BOOL isloading;

@property (nonatomic, strong) ECOViewHierarchyListViewController *listVC;
@property (nonatomic, strong) ECOViewHierarchySceneViewController *sceneVC;
@property (nonatomic, strong) ECOViewHierarchyInfoViewController *infoVC;

@property (nonatomic, strong) NSDictionary *packetDict;
@end

@implementation ECOViewHierarchyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"ECOViewHierarchyContentViewController" bundle:nil];
    self.listVC = [storyBoard instantiateControllerWithIdentifier:@"listVC"];
    self.listVC.delegate = self;
    self.sceneVC = [storyBoard instantiateControllerWithIdentifier:@"sceneVC"];
    self.sceneVC.delegate = self;
    self.infoVC = [storyBoard instantiateControllerWithIdentifier:@"infoVC"];
    self.infoVC.delegate = self;
    [self.splitView addArrangedSubview:self.listVC.view];
    [self.splitView addArrangedSubview:self.sceneVC.view];
    [self.splitView addArrangedSubview:self.infoVC.view];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    if (!self.firstLoad) {
        self.firstLoad = YES;
        self.isLeftSelected = YES;
        self.isRightSelected = NO;
        CGFloat viewWidth = self.view.frame.size.width;
        [self.splitView setPosition:250 ofDividerAtIndex:0];
        [self.splitView setPosition:viewWidth - 235 ofDividerAtIndex:1];
    }
}
- (void)viewDidDisappear {
    [super viewDidDisappear];
    
}
#pragma mark - ECOPluginUIProtocol methods
- (void)refreshWithPackets:(NSArray *)packets {
    NSDictionary *item = (NSDictionary *)packets.lastObject;
    if (!item) {
        return;
    }
    if ([self.packetDict isEqualToDictionary:item]) {
        [self stopLoading];
        return;
    }
    self.packetDict = item;

    NSString *type = item[@"type"];
    if ([type isEqualToString:@"connect"]) {
        //获取viewtree
        [self startLoading];
        !self.plugin.sendBlock ?: self.plugin.sendBlock(@{@"cmd": @"viewtree"});
    }else if ([type isEqualToString:@"viewtree"]) {
        //渲染视图
        NSDictionary *viewData = item[@"data"];
        [self refreshWithViewTreeData:viewData];
        [self stopLoading];
    }else if ([type isEqualToString:@"update"]) {
        //更新数据
        NSDictionary *nodesInfo = item[@"data"];
        [self.sceneVC updateNodesInfo:nodesInfo];
        NSDictionary *extraInfo = item[@"extra"];
        [self.listVC updateEditInfo:extraInfo];
    }
}

#pragma mark - ECOViewHierarchyListSelectionDelegate
- (void)listNodeDidSelectedWithInfo:(NSDictionary *)info {
    [self.infoVC refreshNodeInfo:info];
}
- (void)listNodeDidSelectedWithViewUUID:(NSString *)uuid {
    [self.sceneVC listViewDidSelectedNodeUUID:uuid];
}
#pragma mark - ECOViewHierarchySceneSelectionDelegate
- (void)sceneNodeDidSelected:(NSDictionary *)node {
    [self.listVC sceneNodeSelected:node];
}
#pragma mark - ECOViewHierarchyInfoEditDelegate
- (void)viewDidEditedWithInfo:(NSDictionary *)info {
    !self.plugin.sendBlock ?: self.plugin.sendBlock(info);
}
#pragma mark - 视图渲染
- (void)refreshWithViewTreeData:(NSDictionary *)viewTree {
    [self.listVC refreshViewTreeListWithData:viewTree];
    [self.sceneVC refreshViewTreeSceneWithData:viewTree];
}
#pragma mark - Click Methods
- (IBAction)clickedMenuRefreshButton:(id)sender {
    if (self.isloading) {
        return;
    }
    [self startLoading];
    !self.plugin.sendBlock ?: self.plugin.sendBlock(@{@"cmd": @"viewtree"});
}
- (IBAction)clickedMenuResetButton:(id)sender {
    [self.sceneVC resetDisplayScene];
}

#pragma mark - Helper Methods
- (void)stopLoading {
    self.isloading = NO;
    self.refreshBtn.enabled = YES;
    self.progressIndicator.hidden = YES;
    [self.progressIndicator stopAnimation:nil];}

- (void)startLoading {
    self.isloading = YES;
    self.refreshBtn.hidden = NO;
    self.progressIndicator.hidden = NO;
    [self.progressIndicator startAnimation:nil];
}
@end
