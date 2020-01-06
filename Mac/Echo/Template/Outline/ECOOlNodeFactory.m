//
//  ECOOlNodeFactory.m
//  Echo
//
//  Created by Lux on 2019/8/2.
//  Copyright © 2019 陈爱彬. All rights reserved.
//

#import "ECOOlNodeFactory.h"

@implementation ECOOlNodeFactory

+ (NSDictionary <NSString *, ECOOlNode *> *)nodeInfosFromData:(id)data {
    if ([data isKindOfClass:NSDictionary.class]) {
        return [self nodeInfosFromDictionary:data];
    } else if ([data isKindOfClass:NSArray.class]) {
        return [self nodeInfosFromArray:data parentNode:nil];
    } else {
        ///< 支持 NSArray 或者 NSDictionary
        NSCParameterAssert(nil);
        return nil;
    }
}

+ (NSDictionary <NSString *, ECOOlNode *> *)nodeInfosFromDictionary:(NSDictionary *)data {
    return [self nodeInfosFromDictionary:data parentNode:nil];
}

+ (NSDictionary <NSString *, ECOOlNode *> *)nodeInfosFromDictionary:(NSDictionary *)data parentNode:(ECOOlNode *)parentNode {
    NSMutableDictionary *one = @{}.mutableCopy;
    [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        ECOOlNode *node = [self p_nodeWithKey:key value:obj parentNode:parentNode];
        [one setObject:node forKey:key];
    }];
    return one;
}

+ (NSDictionary <NSString *, ECOOlNode *> *)nodeInfosFromArray:(NSArray *)data parentNode:(ECOOlNode *)parentNode {
    NSMutableDictionary *one = @{}.mutableCopy;
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [self keyWithIndex:idx];
        ECOOlNode *node = [self p_nodeWithKey:key value:obj parentNode:parentNode];
        [one setObject:node forKey:node.key];
    }];
    return one;
}

+ (ECOOlNode *)p_nodeWithKey:(NSString *)key value:(id)value parentNode:(ECOOlNode *)parentNode {
    ECOOlNode *node = [[ECOOlNode alloc] init];
    node.key = key;
    node.value = value;
    node.parentNode = parentNode;
    if (node.valueArray) {
        node.subNodes = [self nodeInfosFromArray:node.valueArray parentNode:node];
    } else if (node.valueDictionary) {
        node.subNodes = [self nodeInfosFromDictionary:node.valueDictionary parentNode:node];
    }
    return node;
}

+ (NSArray *)sortKeysFromDictionary:(NSDictionary *)dict {
    if (!dict || dict.count == 0) {
        return nil;
    }
    return [dict.allKeys sortedArrayUsingComparator:^
            NSComparisonResult(NSString *obj1, NSString *obj2)
    {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
}

+ (NSString *)keyWithIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"[%@]",@(index)];
}

+ (NSInteger)arrayIndexWithKey:(NSString *)key {
    ///< Parse (str)"[x]" => rm '[' and ']' => (int)x
    NSInteger index = NSNotFound;
    NSString *substr = [key substringWithRange:NSMakeRange(1, key.length - 2)];
    if (substr) {
        index = [substr integerValue];
    }
    return index;
}

@end
