//
//  ECOViewHierarchySceneViewController.h
//  Echo
//
//  Created by 陈爱彬 on 2019/6/19. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>
#import "defines.h"

@protocol ECOViewHierarchySceneSelectionDelegate <NSObject>

- (void)sceneNodeDidSelected:(NSDictionary *)node;

@end

@interface ECOViewHierarchySceneViewController : NSViewController

@property (nonatomic, weak) id<ECOViewHierarchySceneSelectionDelegate> delegate;

//刷新场景视图
- (void)refreshViewTreeSceneWithData:(NSDictionary *)dict;

//更新数据信息
- (void)updateNodesInfo:(NSDictionary *)nodesInfo;

//左侧列表选中节点后更新选中状态
- (void)listViewDidSelectedNodeUUID:(NSString *)uuid;

//切换显示模式
- (void)changeDisplayMode:(YVSceneViewDisplayMode)newmode;

//重置
- (void)resetDisplayScene;

@end
