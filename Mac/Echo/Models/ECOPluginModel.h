//
//  ECOPluginModel.h
//  Echo
//
//  Created by 陈爱彬 on 2019/5/15. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>
#import "ECOBasePlugin.h"

@interface ECOPluginModel : NSObject

@property (nonatomic, strong) __kindof ECOBasePlugin *plugin;

- (void)appendPacket:(id)packet;

- (void)clear;

- (NSArray *)packetList;

@end
