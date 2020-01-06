//
//  ECOMemoryLeakManager.h
//  Echo
//
//  Created by yxj on 2019/7/31.
//

#import <Foundation/Foundation.h>

typedef void(^EchoReceivedMemoryLeakRecBlock)(NSDictionary *recDict);



@interface ECOMemoryLeakManager : NSObject

@property (nonatomic, copy) EchoReceivedMemoryLeakRecBlock addBlock;

+ (instancetype)sharedManager;

- (void)addRecord:(NSDictionary *)rec;

@end
