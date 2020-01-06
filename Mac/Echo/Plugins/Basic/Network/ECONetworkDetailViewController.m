//
//  ECONetworkDetailViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/3. Maintain by 陈爱彬
//  Description 
//

#import "ECONetworkDetailViewController.h"
#import "ECONetworkOverviewViewController.h"
#import "ECONetworkRequestViewController.h"
#import "ECONetworkResponseViewController.h"
#import <Masonry/Masonry.h>

@interface ECONetworkDetailViewController ()
@property (weak) IBOutlet NSBox *overviewBgBox;
@property (weak) IBOutlet NSButton *overviewBtn;
@property (weak) IBOutlet NSBox *requestBgBox;
@property (weak) IBOutlet NSButton *requestBtn;
@property (weak) IBOutlet NSBox *responseBgBox;
@property (weak) IBOutlet NSButton *responseBtn;
@property (nonatomic, weak) NSButton *selectedBtn;
@property (weak) IBOutlet NSTabView *tabView;

@property (nonatomic, strong) ECONetworkOverviewViewController *overviewVC;
@property (nonatomic, strong) ECONetworkRequestViewController *requestVC;
@property (nonatomic, strong) ECONetworkResponseViewController *responseVC;

@end

@implementation ECONetworkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupDetailTabViewControllers];
    self.selectedBtn = self.overviewBtn;
    [self updateSelectedButtonView];
    [self.tabView selectTabViewItemAtIndex:0];
    self.overviewBgBox.hidden = NO;
    
}

- (void)setupDetailTabViewControllers {
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"ECONetworkDetailViewController" bundle:nil];
    self.overviewVC = [storyBoard instantiateControllerWithIdentifier:@"overviewVC"];
    self.requestVC = [storyBoard instantiateControllerWithIdentifier:@"requestVC"];
    self.responseVC = [storyBoard instantiateControllerWithIdentifier:@"responseVC"];
    NSTabViewItem *overviewItem = [NSTabViewItem tabViewItemWithViewController:self.overviewVC];
    [self.tabView addTabViewItem:overviewItem];
    NSTabViewItem *requestItem = [NSTabViewItem tabViewItemWithViewController:self.requestVC];
    [self.tabView addTabViewItem:requestItem];
    NSTabViewItem *responseItem = [NSTabViewItem tabViewItemWithViewController:self.responseVC];
    [self.tabView addTabViewItem:responseItem];
}

- (void)updateSelectedButtonView {
    [self.overviewBtn setState:NSControlStateValueOff];
    [self.requestBtn setState:NSControlStateValueOff];
    [self.responseBtn setState:NSControlStateValueOff];
    [self.selectedBtn setState:NSControlStateValueOn];
    self.overviewBgBox.hidden = YES;
    self.requestBgBox.hidden = YES;
    self.responseBgBox.hidden = YES;
}

- (IBAction)clickedOverviewButton:(id)sender {
    self.selectedBtn = self.overviewBtn;
    [self updateSelectedButtonView];
    [self.tabView selectTabViewItemAtIndex:0];
    self.overviewBgBox.hidden = NO;
}

- (IBAction)clickedRequestButton:(id)sender {
    self.selectedBtn = self.requestBtn;
    [self updateSelectedButtonView];
    [self.tabView selectTabViewItemAtIndex:1];
    self.requestBgBox.hidden = NO;
}

- (IBAction)clickedResponseButton:(id)sender {
    self.selectedBtn = self.responseBtn;
    [self updateSelectedButtonView];
    [self.tabView selectTabViewItemAtIndex:2];
    self.responseBgBox.hidden = NO;
}

- (void)setDetailInfo:(NSDictionary *)detailInfo {
    _detailInfo = detailInfo;
    //更新数据
    self.overviewVC.detailInfo = _detailInfo;
    self.requestVC.detailInfo = _detailInfo;
    self.responseVC.detailInfo = _detailInfo;
}
@end
