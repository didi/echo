//
//  ECOPacketClient.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/24. Maintain by 陈爱彬
//  Description 
//

#import "ECOPacketClient.h"
#import <pthread.h>

@interface ECOPacketClient()

@property (nonatomic, strong) ECOChannelManager *channel;
@property (nonatomic, strong) NSMapTable *unSendPackets;
@end

@implementation ECOPacketClient {
    dispatch_queue_t _inPacketsQueue;
    dispatch_queue_t _outPacketsQueue;
    pthread_mutex_t _unSendLock;
}

#pragma mark - LifeCycle
- (void)dealloc {
    pthread_mutex_destroy(&_unSendLock);
}
- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_unSendLock, NULL);
        _inPacketsQueue = dispatch_queue_create("com.echo.inpackets.queue", DISPATCH_QUEUE_SERIAL);
        _outPacketsQueue = dispatch_queue_create("com.echo.outpackets.queue", DISPATCH_QUEUE_SERIAL);
        [self p_createChannel];
    }
    return self;
}
#pragma mark - 数据中转
//发送数据，data数据由接入层传入
- (void)sendPacket:(NSData *)packet
              type:(ECOPacketDataType)type
         extraInfo:(NSDictionary *)extraInfo
            plugin:(__kindof ECOBasePlugin *)plugin
          toDevice:(ECOChannelDeviceInfo *)device {
    if (!packet || ![packet isKindOfClass:[NSData class]]) {
        NSLog(@"Invalid packet data!!!");
        return;
    }
    BOOL isConnected = [self.channel isConnected];
    if (isConnected) {
        dispatch_async(_inPacketsQueue, ^{
            [self.channel sendPacket:packet type:type extraInfo:extraInfo toDevice:device];
        });
    }else{
        [self p_lock];
        NSMutableArray *packets = [self unSendPacketsForPlugin:plugin];
        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        [item setValue:packet forKey:@"packet"];
        [item setValue:@(type) forKey:@"type"];
        [item setValue:extraInfo forKey:@"extraInfo"];
        [packets addObject:item];
        if (packets.count > plugin.cacheNum) {
            [packets removeObjectAtIndex:0];
        }
        [self p_unlock];
    }
}
//发送授权数据
- (void)sendAuthorizationMessageToDevice:(ECOChannelDeviceInfo *)device
                                    state:(ECOAuthorizeResponseType)responseType
                           showAuthAlert:(BOOL)showAuthAlert {
    [self.channel sendAuthorizationMessageToDevice:device state:responseType showAuthAlert:showAuthAlert];
}
//接收到通道层发出的数据
- (void)device:(ECOChannelDeviceInfo *)device receivedChannelData:(NSData *)data extraInfo:(NSDictionary *)extraInfo {
    if (!data) {
        return;
    }
//    dispatch_async(_outPacketsQueue, ^{
        !self.receivedBlock ?: self.receivedBlock(device, data, extraInfo);
//    });
}
//链接IP地址的主机
- (void)connectToClientIPAddress:(NSString *)ipAddress {
    [self.channel connectToClientIPAddress:ipAddress];
}
#pragma mark - 缓存管理
- (void)resendUnSendPackets {
    dispatch_async(_inPacketsQueue, ^{
        [self p_lock];
        NSEnumerator *enumerator = [self.unSendPackets keyEnumerator];
        ECOBasePlugin *plugin = [enumerator nextObject];
        while (plugin) {
            NSMutableArray *packets = [self unSendPacketsForPlugin:plugin];
            for (NSMutableDictionary *item in packets) {
                NSData *packet = item[@"packet"];
                ECOPacketDataType type = [item[@"type"] integerValue];
                NSDictionary *extraInfo = item[@"extraInfo"];
                [self.channel sendPacket:packet type:type extraInfo:extraInfo toDevice:nil];
            }
            plugin = [enumerator nextObject];
        }
        [self.unSendPackets removeAllObjects];
        [self p_unlock];
    });
}
#pragma mark - private
- (void)p_lock {
    pthread_mutex_lock(&_unSendLock);
}
- (void)p_unlock {
    pthread_mutex_unlock(&_unSendLock);
}
- (void)p_createChannel {
    if (!_channel) {
        _channel = [[ECOChannelManager alloc] init];
        __weak typeof(self) weakSelf = self;
        _channel.receivedBlock = ^(ECOChannelDeviceInfo *device, NSData *data, NSDictionary *extraInfo) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf device:device receivedChannelData:data extraInfo:extraInfo];
        };
        _channel.deviceBlock = ^(ECOChannelDeviceInfo *device, BOOL isConnected) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            !strongSelf.deviceBlock ?: strongSelf.deviceBlock(device, isConnected);
        };
        _channel.authStateChangedBlock = ^(ECOChannelDeviceInfo *device, BOOL authState) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            !strongSelf.authStateChangedBlock ?: strongSelf.authStateChangedBlock(device, authState);
            //重发
            if (authState) {
                BOOL isConnected = [strongSelf.channel isConnected];
                if (isConnected) {
                    [strongSelf resendUnSendPackets];
                }
            }
        };
        _channel.requestAuthBlock = ^(ECOChannelDeviceInfo *device, BOOL authState) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            !strongSelf.requestAuthBlock ?: strongSelf.requestAuthBlock(device, authState);
        };
    }
}
#pragma mark - getters
- (NSMapTable *)unSendPackets {
    if (!_unSendPackets) {
        _unSendPackets = [NSMapTable weakToStrongObjectsMapTable];
    }
    return _unSendPackets;
}

- (NSMutableArray *)unSendPacketsForPlugin:(__kindof ECOBasePlugin *)plugin {
    if (plugin == nil || plugin.cacheNum == 0) {
        return nil;
    }
    NSMutableArray *packets = [[self unSendPackets] objectForKey:plugin];
    if (packets == nil) {
        packets = [NSMutableArray array];
        [[self unSendPackets] setObject:packets forKey:plugin];
    }
    return packets;
}

@end
