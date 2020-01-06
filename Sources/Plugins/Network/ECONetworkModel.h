//
//  ECONetworkModel.h
//  Echo
//
//  Created by 陈爱彬 on 2019/6/4. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECONetworkModel : NSObject

/**
 请求url
 */
@property (nonatomic, copy) NSString *urlString;
/**
 cell标题
 */
@property (nonatomic, copy) NSString *title;
/**
 请求baseURL
 */
@property (nonatomic, copy) NSString *baseURL;
/**
 请求path
 */
@property (nonatomic, copy) NSString *path;
/**
 请求类型，GET或POST
 */
@property (nonatomic, copy) NSString *httpMethod;
/**
 配置的请求超时
 */
@property (nonatomic, copy) NSString *timeout;
/**
 httpcode码，成功为200
 */
@property (nonatomic, assign) NSInteger code;
/**
 请求header
 */
@property (nonatomic, copy) NSDictionary *headers;
/**
 请求参数
 */
@property (nonatomic, copy) NSDictionary *urlParams;
/**
 回调header
 */
@property (nonatomic, copy) NSDictionary *responseHeader;
/**
 回调结果
 */
@property (nonatomic, copy) NSDictionary *content;
/**
 body数据
 */
@property (nonatomic, strong) NSData *requestBody;
/**
 请求开始时间
 */
@property (nonatomic, strong) NSDate *startDate;
/**
 请求时间
 */
@property (nonatomic, strong) NSDate *endDate;
/**
 失败时error
 */
@property (nonatomic, strong) NSError *error;

- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
