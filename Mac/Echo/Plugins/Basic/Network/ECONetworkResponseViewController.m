//
//  ECONetworkResponseViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/3. Maintain by 陈爱彬
//  Description 
//

#import "ECONetworkResponseViewController.h"
#import "ECONetworkKeyValueListViewController.h"
#import "ECONetworkScrollTextViewController.h"
#import "ECONetworkJSONViewController.h"

@interface ECONetworkResponseViewController ()

@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSBox *headerBgBox;
@property (weak) IBOutlet NSButton *headersBtn;
@property (weak) IBOutlet NSBox *jsonBgBox;
@property (weak) IBOutlet NSButton *jsonBtn;
@property (weak) IBOutlet NSBox *rawBgBox;
@property (weak) IBOutlet NSButton *rawBtn;

@property (nonatomic, weak) NSButton *selectedBtn;

@property (nonatomic, strong) ECONetworkKeyValueListViewController *headersVC;
@property (nonatomic, strong) ECONetworkJSONViewController *jsonVC;
@property (nonatomic, strong) ECONetworkScrollTextViewController *rawVC;

@property (nonatomic, copy) NSArray *headersList;
@property (nonatomic, copy) NSDictionary *responseDict;
@property (nonatomic, copy) NSString *rawContent;

@end

@implementation ECONetworkResponseViewController

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
    self.jsonVC = [storyBoard instantiateControllerWithIdentifier:@"jsonVC"];
    self.rawVC = [storyBoard instantiateControllerWithIdentifier:@"scrollTextVC"];
    NSTabViewItem *headersItem = [NSTabViewItem tabViewItemWithViewController:self.headersVC];
    [self.tabView addTabViewItem:headersItem];
    NSTabViewItem *jsonItem = [NSTabViewItem tabViewItemWithViewController:self.jsonVC];
    [self.tabView addTabViewItem:jsonItem];
    NSTabViewItem *rawItem = [NSTabViewItem tabViewItemWithViewController:self.rawVC];
    [self.tabView addTabViewItem:rawItem];
    //更新数据
    self.headersVC.paramsList = self.headersList;
    self.jsonVC.jsonDict = self.responseDict;
    self.rawVC.content = self.rawContent;
}

- (void)updateSelectedButtonView {
    [self.headersBtn setState:NSControlStateValueOff];
    [self.jsonBtn setState:NSControlStateValueOff];
    [self.rawBtn setState:NSControlStateValueOff];
    [self.selectedBtn setState:NSControlStateValueOn];
    self.headerBgBox.hidden = YES;
    self.jsonBgBox.hidden = YES;
    self.rawBgBox.hidden = YES;
}

#pragma mark - Public methods
- (void)setDetailInfo:(NSDictionary *)detailInfo {
    _detailInfo = detailInfo;
    //headers
    NSDictionary *headers = _detailInfo[@"responseHeader"];
    NSMutableArray *headersArray = [NSMutableArray array];
    [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        NSDictionary *headerItem = @{@"key": key, @"value": obj};
        [headersArray addObject:headerItem];
    }];
    self.headersList = [headersArray copy];
    self.headersVC.paramsList = self.headersList;
    //json
    self.responseDict = _detailInfo[@"content"];
    self.jsonVC.jsonDict = self.responseDict;
    //raw
    self.rawContent = @"";
    if (self.responseDict) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.responseDict options:NSJSONWritingPrettyPrinted error:nil];
        self.rawContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    self.rawVC.content = self.rawContent;
}
#pragma mark - Actions
- (IBAction)clickedHeadersButton:(id)sender {
    self.selectedBtn = self.headersBtn;
    [self updateSelectedButtonView];
    [self.tabView selectTabViewItemAtIndex:0];
    self.headerBgBox.hidden = NO;
}
- (IBAction)clickedJSONViewButton:(id)sender {
    self.selectedBtn = self.jsonBtn;
    [self updateSelectedButtonView];
    [self.tabView selectTabViewItemAtIndex:1];
    self.jsonBgBox.hidden = NO;
}
- (IBAction)clickedRawViewButton:(id)sender {
    self.selectedBtn = self.rawBtn;
    [self updateSelectedButtonView];
    [self.tabView selectTabViewItemAtIndex:2];
    self.rawBgBox.hidden = NO;
}
@end
