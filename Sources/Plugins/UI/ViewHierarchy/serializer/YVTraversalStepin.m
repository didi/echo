//
//  YVTraversalStepin.m
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVTraversalStepin.h"

@interface YVTraversalStepin()
@property (nonatomic,copy) NSString * assignToViewController;
@property (nonatomic,copy) NSString * viewLevel;
@property (nonatomic,assign) NSInteger viewDeepth;
@property (nonatomic,assign) NSInteger indexRow;
@property (nonatomic,assign) NSInteger indexSection;
@property (nonatomic,assign) BOOL isInTableView;
@property (nonatomic,assign) BOOL isInCollectionView;
@end

@implementation YVTraversalStepin

-(instancetype)init
{
    if (self = [super init]) {
        _assignToViewController = @"";
        _viewLevel = @"";
        _viewDeepth = -1;
        _indexSection = -1;
        _indexRow = -1;
        _isInTableView = NO;
        _isInCollectionView = NO;
    }
    return self;
}

+(YVTraversalStepin*)stepInWithView:(UIView*)v parentInfo:(YVTraversalStepin*)parent
{
    YVTraversalStepin * stenIn        = [[YVTraversalStepin alloc]init];
    NSString * assignToViewController = parent.assignToViewController;
    NSInteger indexRow                = parent.indexRow;
    NSInteger indexSection            = parent.indexSection;
    BOOL isInTableView                = parent.isInTableView;
    BOOL isInCollectionView           = parent.isInCollectionView;
    
    UIResponder * nextResponder = v.nextResponder;
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        assignToViewController = NSStringFromClass(nextResponder.class);
    }else if ([nextResponder isKindOfClass:[UITableView class]] && [v isKindOfClass:[UITableViewCell class]]) {
        isInTableView = YES;
        UITableView * tableview = (UITableView *)nextResponder;
        UITableViewCell * cv = (UITableViewCell *)v;
        NSIndexPath * indexpath = [tableview indexPathForCell:cv];
        if (indexpath) {
            indexRow = indexpath.row;
            indexSection = indexpath.section;
        }
    }else if ([nextResponder isKindOfClass:[UICollectionView class]] && [v isKindOfClass:[UICollectionViewCell class]]){
        isInCollectionView = YES;
        UICollectionView * collectionview = (UICollectionView *)nextResponder;
        UICollectionViewCell * cv = (UICollectionViewCell *)v;
        NSIndexPath * indexpath = [collectionview indexPathForCell:cv];
        if (indexpath) {
            indexRow = indexpath.row;
            indexSection = indexpath.section;
        }
    }
    
    stenIn.assignToViewController = assignToViewController;
    stenIn.viewLevel              = [NSString stringWithFormat:@"%@/%ld",parent.viewLevel,[v.superview.subviews indexOfObject:v]];
    stenIn.viewDeepth             = parent.viewDeepth + 1;
    stenIn.indexRow               = indexRow;
    stenIn.indexSection           = indexSection;
    stenIn.isInTableView          = isInTableView;
    stenIn.isInCollectionView     = isInCollectionView;
    return stenIn;
}

-(NSDictionary*)stepinfo
{
    return @{
             @"assign_to_viewcontroller":self.assignToViewController,
             @"view_level":self.viewLevel,
             @"view_deepth":@(self.viewDeepth),
             @"index_row":@(self.indexRow),
             @"index_section":@(self.indexSection),
             @"is_in_tableview":@(self.isInTableView),
             @"is_in_collectionview":@(self.isInCollectionView),
             };
}
@end
