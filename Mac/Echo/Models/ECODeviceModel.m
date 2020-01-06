//
//  ECODeviceModel.m
//  Echo
//
//  Created by 陈爱彬 on 2019/5/15. Maintain by 陈爱彬
//  Description 
//

#import "ECODeviceModel.h"

@implementation ECODeviceModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.projects = @[].mutableCopy;
    }
    return self;
}

- (BOOL)isConnected {
    BOOL v = NO;
    for (ECOProjectModel *pj in self.projects) {
        if (pj.deviceInfo.isConnected) {
            v = YES;
            break;
        }
    }
    return v;
}

- (void)setSelectedProject:(ECOProjectModel *)selectedProject {
    if (_selectedProject == selectedProject) {
        return;
    }
    _selectedProject = selectedProject;
}

- (void)appendProject:(ECOProjectModel *)project {
    [self.projects addObject:project];
    //选中
    if (self.projects.count > 0 && !self.selectedProject) {
        self.selectedProject = self.projects[0];
    }
}

- (BOOL)updateWithDevice:(ECOChannelDeviceInfo *)deviceInfo plugin:(__kindof ECOBasePlugin *)plugin packet:(id)packetData {
    if (!self.hasPackets) {
        if (plugin && packetData) {
            self.hasPackets = YES;
        }
    }
    __block ECOProjectModel *existProjectModel = nil;
    [self.projects enumerateObjectsUsingBlock:^(ECOProjectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.deviceInfo.appInfo.appId isEqualToString:deviceInfo.appInfo.appId]) {
            existProjectModel = obj;
            *stop = YES;
        }
    }];
    if (existProjectModel) {
        return [existProjectModel updateWithPlugin:plugin packet:packetData];
    }else{
        ECOProjectModel *projectModel = [[ECOProjectModel alloc] init];
        projectModel.deviceInfo = deviceInfo;
        [projectModel updateWithPlugin:plugin packet:packetData];
        [self appendProject:projectModel];
        return YES;
    }
}

@end
