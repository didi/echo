//
//  ECOSceneView.h
//  Echo
//
//  Created by 陈爱彬 on 2019/6/19. Maintain by 陈爱彬
//  Description 
//

#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ECOSceneViewDelegate <NSObject>

-(void)sceneView:(SCNView*)scnview didSelectedNode:(SCNNode*)node;

@end

@interface ECOSceneView : SCNView

@property(nonatomic,weak) id <ECOSceneViewDelegate> delegate;

-(void)selectedNode:(NSString*)uuid;

@end

NS_ASSUME_NONNULL_END
