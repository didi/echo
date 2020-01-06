//
//  ECOProjectModel.m
//  Echo
//
//  Created by 陈爱彬 on 2019/5/16. Maintain by 陈爱彬
//  Description 
//

#import "ECOProjectModel.h"
#import "ECOPacketsDispatcher.h"

@implementation ECOProjectModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.plugins = @[].mutableCopy;
    }
    return self;
}

- (void)appendPlugin:(ECOPluginModel *)plugin {
    [self.plugins addObject:plugin];
    //选中
    if (self.plugins.count > 0 && !self.selectedPlugin) {
        self.selectedPlugin = self.plugins[0];
    }
}

- (BOOL)updateWithPlugin:(__kindof ECOBasePlugin *)plugin packet:(id)packetData {
    if (!plugin) {
        return NO;
    }
    __block ECOPluginModel *existPluginModel = nil;
    [self.plugins enumerateObjectsUsingBlock:^(ECOPluginModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.plugin.name isEqualToString:plugin.name]) {
            existPluginModel = obj;
            *stop = YES;
        }
    }];
    if (existPluginModel) {
        [existPluginModel appendPacket:packetData];
        return NO;
    }else{
        ECOPluginModel *pluginModel = [[ECOPluginModel alloc] init];
        pluginModel.plugin = plugin;
        [pluginModel appendPacket:packetData];
        [self appendPlugin:pluginModel];
        return YES;
    }
}
@end
