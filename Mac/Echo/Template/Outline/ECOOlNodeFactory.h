//
//  ECOOlNodeFactory.h
//  Echo
//
//  Created by Lux on 2019/8/2.
//  Copyright © 2019 陈爱彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECOOlNode.h"

#define NodeType NSString *, ECOOlNode *

typedef NSDictionary <NodeType> ECONodeDict;

NS_ASSUME_NONNULL_BEGIN

@interface ECOOlNodeFactory : NSObject

/*!
 工厂将数据结构都做成字典并以 ECOOlNode 对象存储, data 只支持 NSArray 和 NSDictionary
 @warning 数组也会转成字典，key 值特殊处理成 @"[index]"，可以使用 keyWithIndex: 和 arrayIndexWithKey: 两个方法对 index 进行转化
 */
+ (ECONodeDict *)nodeInfosFromData:(id)data;

/*!
 获得被排序后的 key 值队列
 */
+ (NSArray *)sortKeysFromDictionary:(NSDictionary *)dict;

/*!
 工厂加工数组对应的 (NSInteger)index 为 key : @"[index]"
 */
+ (NSString *)keyWithIndex:(NSInteger)index;

/*!
 工厂将字符串 key : @"[index]" 转换为 (NSInteger)index
 #warning 如果返回 NSNotFound 表示从 key 中获取 index 失败；
 */
+ (NSInteger)arrayIndexWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
