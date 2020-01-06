//
//  ECOOlNode.h
//  Echo
//
//  Created by Lux on 2019/8/2.
//  Copyright © 2019 陈爱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 释义：
    ECO = Echo, Ol = Outline
 */
@interface ECOOlNode : NSObject

/*!
 节点的 Key 值
 */
@property (nonatomic, copy) NSString *key;

/*!
 节点 value 的类型
 */
@property (nonatomic, copy) NSString *type;

/*!
 子节点，对象的key 值会有两种类型
 */
@property (nonatomic, strong) NSDictionary <NSString*,ECOOlNode*> *subNodes;

/*!
 当前节点在 outline 中的 value，目前支持的数据是:
 NSArray、NSString、NSNumber、NSDictionary
 */
@property (nonatomic, strong) id value;
@property (nonatomic, strong, readonly) NSData   *valueData;    ///< value有值且为NSData
@property (nonatomic, strong, readonly) NSDate   *valueDate;    ///< value有值且为NSDate
@property (nonatomic, strong, readonly) NSArray  *valueArray;   ///< value有值且为NSArray
@property (nonatomic, strong, readonly) NSString *valueString;  ///< value有值且为NSString
@property (nonatomic, strong, readonly) NSNumber *valueNumber;  ///< value有值且为NSNumber
@property (nonatomic, strong, readonly) NSDictionary *valueDictionary;  ///< value有值且为NSDictionary

- (NSString *)nodeString;

/*!
 当前节点在树的层级（level == 0 是根节点）
 @default NSNotFound
 */
@property (nonatomic, assign, readonly) NSUInteger level;

/*!
 父节点
 */
@property (nonatomic, strong) ECOOlNode *parentNode;

/*!
 当前节点透传的其他自定义数据
 */
@property (nonatomic, strong) id userInfo;

/*!
 是否支持修改
 */
@property (nonatomic, assign, getter=isEditable) BOOL editable;

/*!
 是否展开
 */
@property (nonatomic, assign) BOOL expand;

/*!
 删除某个子节点
 */
- (BOOL)removeSubNode:(ECOOlNode *)node;

/*!
 返回当前 value 的类型字符串, 不支持的类型会返回 @“Undefine”
 */
- (NSString *)valueTypeString;

+ (BOOL)isSupportEditCls:(id)cls;

@end
