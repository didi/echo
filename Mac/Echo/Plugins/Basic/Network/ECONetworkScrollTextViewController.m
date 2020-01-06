//
//  ECONetworkScrollTextViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/3. Maintain by 陈爱彬
//  Description 
//

#import "ECONetworkScrollTextViewController.h"

@interface ECONetworkScrollTextViewController ()

@property (unsafe_unretained) IBOutlet NSTextView *textView;
@end

@implementation ECONetworkScrollTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.textView.font = [NSFont systemFontOfSize:12];
    self.textView.string = self.content ?: @"";
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.textView.string = _content ?: @"";
}
@end
