//
//  ECONSLogManager.h
//  Echo
//
//  Created by 陈爱彬 on 2019/5/29. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>

typedef void(^EchoReceivedNSLogBlock)(NSDictionary *logDict);

@interface ECONSLogManager : NSObject

@property (nonatomic, copy) EchoReceivedNSLogBlock addBlock;

+ (instancetype)shared;

- (void)addNSLog:(NSString *)log;

@end
