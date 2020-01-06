//
//  ECOOlNode.m
//  Echo
//
//  Created by Lux on 2019/8/2.
//  Copyright © 2019 陈爱彬. All rights reserved.
//

#import "ECOOlNode.h"

@implementation ECOOlNode

- (instancetype)init {
    self = [super init];
    if (self) {
        _level = NSNotFound;
        _editable = YES;
        _expand = NO;
    }
    return self;
}

- (void)setParentNode:(ECOOlNode *)parentNode {
    if (_parentNode != parentNode) {
        _parentNode  = parentNode;
    }
    if (!parentNode) {
        _level = 0;
    } else {
        _level = parentNode.level + 1;
    }
}

#pragma mark - ---| Quick Access |---

#define RETURN_TRANS_TYPE(_type_) \
if (![self value]) return nil; \
if (![self.value isKindOfClass:_type_.class]) return nil; \
return (_type_ *)self.value;

- (NSArray *)valueArray {
    RETURN_TRANS_TYPE(NSArray);
}

- (NSString *)valueString {
    RETURN_TRANS_TYPE(NSString);
}

- (NSNumber *)valueNumber {
    RETURN_TRANS_TYPE(NSNumber);
}

- (NSDictionary *)valueDictionary {
    RETURN_TRANS_TYPE(NSDictionary);
}

- (NSData *)valueData {
    RETURN_TRANS_TYPE(NSData);
}

- (NSDate *)valueDate {
    RETURN_TRANS_TYPE(NSDate);
}

- (NSString *)valueTypeString {
    NSString *typeStr = @"Undefine";
    if (self.valueArray) {
        typeStr = @"NSArray";
    } else if (self.valueDictionary) {
        typeStr = @"NSDictionary";
    } else if (self.valueNumber) {
        typeStr = @"NSNumber";
    } else if (self.valueString) {
        typeStr = @"NSString";
    } else if (self.valueData) {
        typeStr = @"NSData";
    } else if (self.valueDate) {
        typeStr = @"NSDate";
    }
    return typeStr;
}

- (NSString *)nodeString {
    NSString *typeStr = nil;
    if (self.valueNumber) {
        typeStr = [self.value stringValue];;
    } else if (self.valueString) {
        typeStr = [self value];
    } else if (self.valueData) {
        typeStr = [self.value base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else if (self.valueDate) {
        NSDateFormatter *one = [[NSDateFormatter alloc] init];
        one.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        one.timeZone = [NSTimeZone systemTimeZone];
        typeStr = [one stringFromDate:self.value];
    }
    return typeStr;
}

#pragma mark - ---| Node Manager |---

- (BOOL)removeSubNode:(ECOOlNode *)node {
    if (self.subNodes && self.subNodes.count > 0) {
        NSMutableDictionary *subNodes = self.subNodes.mutableCopy;
        [subNodes removeObjectForKey:node.key];
        self.subNodes = subNodes.copy;
        return YES;
    }
    return NO;
}

@end
