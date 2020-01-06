//
//  ECOBasePlugin.h
//  Echo
//
//  Created by 陈爱彬 on 2019/5/30. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>
#import "ECOCoreDefines.h"
#import "ECOChannelDeviceInfo.h"

FOUNDATION_EXPORT NSString * const ECOUITemplateType_ListDetail;
FOUNDATION_EXPORT NSString * const ECOUITemplateType_Outline;
FOUNDATION_EXPORT NSString * const ECOUITemplateType_H5;
FOUNDATION_EXPORT NSString * const ECOUITemplateType_Network;

//给所有设备发送消息
typedef void(^ECOPluginSendJSONBlock)(id data);
typedef void(^ECOPluginSendDataBlock)(NSData *data);

//给单个设备发送消息
typedef void(^ECOPluginDeviceSendJSONBlock)(ECOChannelDeviceInfo *device, id data);
typedef void(^ECOPluginDeviceSendDataBlock)(ECOChannelDeviceInfo *device, NSData *data);

@interface ECOBasePlugin : NSObject

/**
 插件名称，如“网络请求”
 */
@property (nonatomic, copy) NSString *name;

/**
 插件对应的UI渲染模板
 */
@property (nonatomic, copy) NSString *templateName;

/**
 插件渲染模板的结构数据
 */
@property (nonatomic, strong) id templateData;

/**
 插件版本号，当Mac端的模板和SDK端的版本号不一致时，会提示不兼容，建议升级至适配代码
 */
@property (nonatomic, assign) NSInteger version;

/**
 发送数据的回调block，底层会对数据做JSON编解码再传输
 */
@property (nonatomic, copy) ECOPluginSendJSONBlock sendBlock;

/**
 发送普通NSData数据，底层不会做JSON编解码
 */
@property (nonatomic, copy) ECOPluginSendDataBlock sendDataBlock;

/**
 发送数据的回调block，底层会对数据做JSON编解码再传输
 */
@property (nonatomic, copy) ECOPluginDeviceSendJSONBlock deviceSendBlock;

/**
 发送普通NSData数据，底层不会做JSON编解码
 */
@property (nonatomic, copy) ECOPluginDeviceSendDataBlock deviceSendDataBlock;

/**
 未连接前最大缓存条数
 */
@property (nonatomic, assign) NSInteger cacheNum;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)toDictionary;

/**
 注册渲染的UI模板以及模板对应的显示数据

 @param templateName 模板名称
 @param templateData 模板结构
 */
- (void)registerTemplate:(NSString *)templateName
                    data:(id)templateData;

/**
 接收到数据
 
 @param data 数据内容
 */
- (void)didReceivedPacketData:(id)data fromDevice:(ECOChannelDeviceInfo *)device;

//设备授权状态发生变更
- (void)device:(ECOChannelDeviceInfo *)device didChangedAuthState:(BOOL)isAuthed;

//通用的时间formatter
- (NSDateFormatter *)dateFormatter;

@end
