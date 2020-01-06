//
//  ECOGeneralLogManager.h
//  EchoSDK
//
//  Created by yxj on 2019/8/6.
//

#import <Foundation/Foundation.h>

typedef void(^ECORecvDictBlock)(NSDictionary * _Nullable recDict);

NS_ASSUME_NONNULL_BEGIN

@interface ECOGeneralLogManager : NSObject

@property (nonatomic, copy, nullable) ECORecvDictBlock addBlock;

+ (instancetype)sharedManager;

///> {logType: error/warn/..., log:str }
- (void)addRecord:(NSDictionary *)rec;
///> {logType: general, log:str }
- (void)addGeneralLog:(NSString *)log;
- (void)addVerboseLog:(NSString *)log;
- (void)addDebugLog:(NSString *)log;
- (void)addInfoLog:(NSString *)log;
- (void)addWarnLog:(NSString *)log;
- (void)addErrorLog:(NSString *)log;
- (void)addLog:(NSString *)log customType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
