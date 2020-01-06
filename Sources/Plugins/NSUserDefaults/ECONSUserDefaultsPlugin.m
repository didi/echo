//
//  ECONSUserDefaultsPlugin.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/21. Maintain by 陈爱彬
//  Description 
//

#import "ECONSUserDefaultsPlugin.h"
#import "ECOClient.h"

@interface ECONSUserDefaultsPlugin()

//@property (nonatomic, assign) BOOL isConnected;
//是否有设备授权连接过
@property (nonatomic, assign) BOOL isHasAuthed;

@end

@implementation ECONSUserDefaultsPlugin

+ (void)load {
    [[ECOClient sharedClient] registerPlugin:[self class]];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setName:@"NSUserDefaults"];
        [self registerTemplate:ECOUITemplateType_Outline data:nil];

//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserDefaultsDidChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
//        [self sendUserDefaultsRepresentionToDevice:nil];
    }
    return self;
}

////NSUserDefaults数据变更通知
//- (void)onUserDefaultsDidChanged:(NSNotification *)noti {
//    [self sendUserDefaultsRepresentionToDevice:nil];
//}

//发送数据
- (void)sendUserDefaultsRepresentionToDevice:(ECOChannelDeviceInfo *)device {
    if (self.isHasAuthed) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        id sendInfo = dict;
//        id sendInfo = [self recursivelyFilterInvalidJSONWriteData:dict];
        if (device) {
            !self.deviceSendBlock ?: self.deviceSendBlock(device, @{@"data": sendInfo ?: @{}});
        }else{
            !self.sendBlock ?: self.sendBlock(@{@"data": sendInfo ?: @{}});
        }
    }
}
////递归地过滤掉JSON转换不合法的NSDate和NSData数据
//- (id)recursivelyFilterInvalidJSONWriteData:(id)item {
//    if ([item isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *dict = (NSDictionary *)item;
//        NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:dict];
//        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            if ([obj isKindOfClass:[NSDate class]]) {
//                [sendDict removeObjectForKey:key];
//            }else if ([obj isKindOfClass:[NSData class]]) {
//                [sendDict removeObjectForKey:key];
//            }else if ([obj isKindOfClass:[NSArray class]] ||
//                      [obj isKindOfClass:[NSDictionary class]]) {
//                id result = [self recursivelyFilterInvalidJSONWriteData:obj];
//                [sendDict setValue:result forKey:key];
//            }
//        }];
//        return sendDict;
//    } else if ([item isKindOfClass:[NSArray class]]) {
//        NSArray *list = (NSArray *)item;
//        NSMutableArray *sendArray = [NSMutableArray arrayWithArray:list];
//        for (NSInteger i = list.count - 1; i >= 0; i--) {
//            id obj = list[i];
//            if ([obj isKindOfClass:[NSDate class]]) {
//                [sendArray removeObjectAtIndex:i];
//            }else if ([obj isKindOfClass:[NSData class]]) {
//                [sendArray removeObjectAtIndex:i];
//            }else if ([obj isKindOfClass:[NSArray class]] ||
//                      [obj isKindOfClass:[NSDictionary class]]) {
//                id result = [self recursivelyFilterInvalidJSONWriteData:obj];
//                [sendArray replaceObjectAtIndex:i withObject:result];
//            }
//        }
//        return sendArray;
//    }
//    return item;
//}

#pragma mark - ECOBasePlugin Methods
//连接状态变更
- (void)device:(ECOChannelDeviceInfo *)device didChangedAuthState:(BOOL)isAuthed {
    if (isAuthed) {
        self.isHasAuthed = YES;
    }
    [self sendUserDefaultsRepresentionToDevice:device];
}

//接收到Mac端CMD数据
- (void)didReceivedPacketData:(id)data fromDevice:(ECOChannelDeviceInfo *)device {
    NSDictionary *cmdData = (NSDictionary *)data;
    NSString *cmd = cmdData[@"cmd"];
    NSDictionary *info = cmdData[@"info"];
    if ([cmd isEqualToString:@"set"]) {
        NSString *key = info[@"key"];
        id value = info[@"value"];
        [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([cmd isEqualToString:@"del"]) {
        NSString *key = info[@"key"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([cmd isEqualToString:@"refresh"]) {
        [self sendUserDefaultsRepresentionToDevice:device];
    }
}

@end
