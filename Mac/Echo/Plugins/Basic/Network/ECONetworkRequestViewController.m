//
//  ECONetworkRequestViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/3. Maintain by 陈爱彬
//  Description 
//

#import "ECONetworkRequestViewController.h"
#import "ECONetworkKeyValueListViewController.h"
#import "ECONetworkScrollTextViewController.h"
#import "ECONetworkJSONViewController.h"

@interface ECONetworkRequestViewController ()
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSBox *headerBgBox;
@property (weak) IBOutlet NSButton *headersBtn;
@property (weak) IBOutlet NSBox *queryBgBox;
@property (weak) IBOutlet NSButton *queryBtn;
@property (weak) IBOutlet NSBox *bodyBgBox;
@property (weak) IBOutlet NSButton *bodyBtn;
@property (nonatomic, weak) NSButton *selectedBtn;

@property (nonatomic, strong) ECONetworkKeyValueListViewController *headersVC;
@property (nonatomic, strong) ECONetworkKeyValueListViewController *queryVC;
@property (nonatomic, strong) ECONetworkScrollTextViewController *bodyVC;

@property (nonatomic, copy) NSArray *headersList;
@property (nonatomic, copy) NSArray *queryList;
@end

@implementation ECONetworkRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupDetailTabViewControllers];
    self.selectedBtn = self.headersBtn;
    [self updateSelectedButtonView];
    [self.tabView selectTabViewItemAtIndex:0];
    self.headerBgBox.hidden = NO;
}
#pragma mark - UI视图
- (void)setupDetailTabViewControllers {
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"ECONetworkDetailViewController" bundle:nil];
    self.headersVC = [storyBoard instantiateControllerWithIdentifier:@"keyValueVC"];
    self.queryVC = [storyBoard instantiateControllerWithIdentifier:@"keyValueVC"];
    self.bodyVC = [storyBoard instantiateControllerWithIdentifier:@"scrollTextVC"];
    NSTabViewItem *headersItem = [NSTabViewItem tabViewItemWithViewController:self.headersVC];
    [self.tabView addTabViewItem:headersItem];
    NSTabViewItem *queryItem = [NSTabViewItem tabViewItemWithViewController:self.queryVC];
    [self.tabView addTabViewItem:queryItem];
    NSTabViewItem *bodyItem = [NSTabViewItem tabViewItemWithViewController:self.bodyVC];
    [self.tabView addTabViewItem:bodyItem];
    //设置内容
    self.headersVC.paramsList = self.headersList;
    self.queryVC.paramsList = self.queryList;
}

- (void)updateSelectedButtonView {
    [self.headersBtn setState:NSControlStateValueOff];
    [self.queryBtn setState:NSControlStateValueOff];
    [self.bodyBtn setState:NSControlStateValueOff];
    [self.selectedBtn setState:NSControlStateValueOn];
    self.headerBgBox.hidden = YES;
    self.queryBgBox.hidden = YES;
    self.bodyBgBox.hidden = YES;
}

#pragma mark - Public methods
- (void)setDetailInfo:(NSDictionary *)detailInfo {
    _detailInfo = detailInfo;
    //headers
    NSDictionary *headers = _detailInfo[@"headers"] ?: @{};
    NSMutableArray *headersArray = [NSMutableArray array];
    [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        NSDictionary *headerItem = @{@"key": key, @"value": obj};
        [headersArray addObject:headerItem];
    }];
    self.headersList = [headersArray copy];
    self.headersVC.paramsList = self.headersList;
    //query
    NSDictionary *urlParams = _detailInfo[@"urlParams"] ?: @{};
    NSMutableArray *queryArray = [NSMutableArray array];
    [urlParams enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        NSDictionary *queryItem = @{@"key": key, @"value": obj};
        [queryArray addObject:queryItem];
    }];
    self.queryList = [queryArray copy];
    self.queryVC.paramsList = self.queryList;
    //body
    id body = _detailInfo[@"body"];
    self.bodyVC.content = body ? [NSString stringWithFormat:@"%@", body] : @"";
}
#pragma mark - Actions
- (IBAction)clickedHeadersButton:(id)sender {
    self.selectedBtn = self.headersBtn;
    [self updateSelectedButtonView];
    [self.tabView selectTabViewItemAtIndex:0];
    self.headerBgBox.hidden = NO;
}
- (IBAction)clickedQueryStringButton:(id)sender {
    self.selectedBtn = self.queryBtn;
    [self updateSelectedButtonView];
    [self.tabView selectTabViewItemAtIndex:1];
    self.queryBgBox.hidden = NO;
}
- (IBAction)clickedBodyButton:(id)sender {
    self.selectedBtn = self.bodyBtn;
    [self updateSelectedButtonView];
    [self.tabView selectTabViewItemAtIndex:2];
    self.bodyBgBox.hidden = NO;
}

@end
