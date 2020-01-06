//
//  ECOPluginModel.m
//  Echo
//
//  Created by 陈爱彬 on 2019/5/15. Maintain by 陈爱彬
//  Description 
//

#import "ECOPluginModel.h"

@interface ECOPluginModel()
{
    dispatch_queue_t _packetQueue;
}
@property (nonatomic, strong) NSMutableArray *packets;
@end

@implementation ECOPluginModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.packets = @[].mutableCopy;
        _packetQueue = dispatch_queue_create("com.echo.packetQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)clear {
    dispatch_async(_packetQueue, ^{
        [self.packets removeAllObjects];
    });
}

- (void)appendPacket:(id)packet {
    if (!packet) {
        return;
    }
    dispatch_async(_packetQueue, ^{
        [self.packets addObject:packet];
    });
}

- (NSArray *)packetList {
    __block NSArray *list = nil;
    dispatch_sync(_packetQueue, ^{
        list = [self.packets copy];
    });
    return list;
}

@end
