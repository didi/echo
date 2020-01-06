//
//  UIView+YVViewTree.h
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIView (YVViewTree)
+(NSString*)rootViewTreeString;
+(NSDictionary*)rootViewTreeDictionary;
@end

NS_ASSUME_NONNULL_END
