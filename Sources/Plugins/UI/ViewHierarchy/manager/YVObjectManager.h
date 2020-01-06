//
//  YVObjectManager.h
//  libyourview
//
//  Created by bliss_ddo on 2019/5/5.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YVTraversalContext.h"
NS_ASSUME_NONNULL_BEGIN

@interface YVObjectManager : NSObject
+(YVObjectManager *)sharedInstance;
@property (nonatomic,strong) YVTraversalContext * context;
@end

NS_ASSUME_NONNULL_END
