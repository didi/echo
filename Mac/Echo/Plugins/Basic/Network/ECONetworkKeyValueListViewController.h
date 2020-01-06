//
//  ECONetworkKeyValueListViewController.h
//  Echo
//
//  Created by 陈爱彬 on 2019/6/3. Maintain by 陈爱彬
//  Description 
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECONetworkKeyValueListViewController : NSViewController

@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *paramsList;

@end

NS_ASSUME_NONNULL_END
