//
//  ECOViewHierarchyInfoViewController.h
//  Echo
//
//  Created by 陈爱彬 on 2019/6/19. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ECOViewHierarchyInfoEditDelegate <NSObject>

- (void)viewDidEditedWithInfo:(NSDictionary *)info;

@end

@interface ECOViewHierarchyInfoViewController : NSViewController

@property (nonatomic, weak) id<ECOViewHierarchyInfoEditDelegate> delegate;

//刷新节点信息
- (void)refreshNodeInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
