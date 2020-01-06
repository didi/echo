//
//  ECOBasePlugin.m
//  Echo
//
//  Created by 陈爱彬 on 2019/5/30. Maintain by 陈爱彬
//  Description 
//

#import "ECOBasePlugin.h"

NSString * const ECOUITemplateType_ListDetail = @"LIST_DETAIL";
NSString * const ECOUITemplateType_Outline    = @"OUTLINE";
NSString * const ECOUITemplateType_H5         = @"H5";
NSString * const ECOUITemplateType_Network    = @"NETWORK";

static NSDateFormatter *dateFormatter = nil;

@implementation ECOBasePlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cacheNum = 10;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.name = dict[@"name"] ?: @"";
        self.templateName = dict[@"templateName"] ?: @"";
        self.templateData = dict[@"templateData"];
        self.cacheNum = 10;
    }
    return self;
}

//注册模板
- (void)registerTemplate:(NSString *)templateName
                    data:(id)templateData {
    self.templateName = templateName;
    self.templateData = templateData;
}

- (NSDictionary *)toDictionary {
    NSDictionary *pluginDict = @{@"name": self.name ?: @"",
                                 @"templateName": self.templateName ?: @""
                                 };
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:pluginDict];
    if (self.templateData) {
        [dict setValue:self.templateData forKey:@"templateData"];
    }
    return [dict copy];
}

/**
 接收到数据
 
 @param data 数据内容
 */
- (void)didReceivedPacketData:(id)data
                   fromDevice:(ECOChannelDeviceInfo *)device {
    
}

//设备授权状态发生变更
- (void)device:(ECOChannelDeviceInfo *)device didChangedAuthState:(BOOL)isAuthed {
    
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ECOBasePlugin class]]) {
        return NO;
    }
    __kindof ECOBasePlugin *plugin = (__kindof ECOBasePlugin *)object;
    if (![plugin.name isEqual:self.name]) {
        return NO;
    }
    return YES;
}

- (NSDateFormatter *)dateFormatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm:ss";
    }
    return dateFormatter;
}

@end
