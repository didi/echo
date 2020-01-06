//
//  NSObject+YVNodeInfo.h
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YVNodeInfo)
-(NSDictionary*)nodeInfo;
-(NSString*)ecoNodeAddress;
@end

NS_ASSUME_NONNULL_END
