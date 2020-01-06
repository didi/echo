//
//  ECOViewBorderInspector.h
//  EchoSDK
//
//  Created by zhanghe on 2019/8/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECOViewBorderInspector : NSObject

@property (nonatomic, assign) BOOL showViewBorder;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
