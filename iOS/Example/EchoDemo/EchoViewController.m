//
//  EchoViewController.m
//  Echo
//
//  Created by 136998328@qq.com on 04/15/2019.
//  Copyright (c) 2019 136998328@qq.com. All rights reserved.
//

#import "EchoViewController.h"
#import "EchoTableViewCell.h"

@interface EchoViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation EchoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EchoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pluginCell"];
    NSDictionary *content = @{@"title": [NSString stringWithFormat:@"标题%@",@(indexPath.row + 1)],
                              @"detail": [NSString stringWithFormat:@"描述%@",@(indexPath.row + 1)]};
    cell.content = content;
    
    return cell;
}
#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
