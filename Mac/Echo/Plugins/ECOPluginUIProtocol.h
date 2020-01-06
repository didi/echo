//
//  ECOPluginUIProtocol.h
//  Echo
//
//  Created by 陈爱彬 on 2019/5/6. Maintain by 陈爱彬
//  Description 
//

#ifndef ECOPluginUIProtocol_h
#define ECOPluginUIProtocol_h

#import "ECOBasePlugin.h"

@protocol ECOPluginUIProtocol <NSObject>

@optional
/**
 刷新Tab视图

 @param packets 数据包列表
 */
- (void)refreshWithPackets:(NSArray *)packets;

@property (nonatomic, weak) __kindof ECOBasePlugin *plugin;

/**
 模板数据
 */
@property (nonatomic, strong) id templateData;

/**
 插件是否兼容，和Plugin的version对比，如果模板版本低于plugin.version，则会显示不兼容信息

 @return YES为兼容，NO为不兼容
 */
- (BOOL)isPluginCompatible;

@end

#endif /* ECOPluginUIProtocol_h */
