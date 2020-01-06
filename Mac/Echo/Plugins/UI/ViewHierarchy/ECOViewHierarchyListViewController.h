//
//  ECOViewHierarchyListViewController.h
//  Echo
//
//  Created by 陈爱彬 on 2019/6/19. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ECOViewHierarchyListSelectionDelegate <NSObject>

- (void)listNodeDidSelectedWithInfo:(NSDictionary *)info;

- (void)listNodeDidSelectedWithViewUUID:(NSString *)uuid;

@end

@interface ECOViewHierarchyListViewController : NSViewController

@property (nonatomic, weak) id<ECOViewHierarchyListSelectionDelegate> delegate;

//刷新列表侧
- (void)refreshViewTreeListWithData:(NSDictionary *)dict;

//视图场景的选中节点变更了
- (void)sceneNodeSelected:(NSDictionary *)nodeInfo;

//更新编辑后的信息
- (void)updateEditInfo:(NSDictionary *)extraInfo;

@end

NS_ASSUME_NONNULL_END
