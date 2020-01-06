//
//  ECONetworkJSONViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/3. Maintain by 陈爱彬
//  Description 
//

#import "ECONetworkJSONViewController.h"
#import <WebKit/WebView.h>
#import <WebKit/WebScriptObject.h>
#import <WebKit/WebFrame.h>
#import "ECODarkModeHelper.h"

@interface ECONetworkJSONViewController ()
<WebFrameLoadDelegate>

@property (weak) IBOutlet WebView *webView;
@property (nonatomic, assign) BOOL isWebViewLoaded;
@property (nonatomic, copy) NSString *jsonString;

@end

@implementation ECONetworkJSONViewController

- (void)dealloc
{
    [[ECODarkModeHelper shared] unsubscribeDarkModeChangedEvent:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    __weak typeof(self) weakSelf = self;
    [[ECODarkModeHelper shared] subscribeDarkModeChangedEvent:self handler:^(BOOL isDarkMode) {
        [weakSelf refreshJSONEditorTheme:isDarkMode];
    } immediately:NO];
    //添加视图
    [self updateJSONView];
}

- (void)setJsonDict:(NSDictionary *)jsonDict {
    _jsonDict = jsonDict;
    if (_jsonDict) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_jsonDict options:NSJSONWritingPrettyPrinted error:nil];
        self.jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    [self updateJSONView];
}

- (void)updateJSONView {
    if (self.isWebViewLoaded) {
        [self renderJSONString];
    }else{
        [self setupWebJSONViewer];
    }
}

//适配DarkMode效果
- (void)refreshJSONEditorTheme:(BOOL)isDarkMode {
    if (isDarkMode) {
        [self.webView.windowScriptObject callWebScriptMethod:@"changeThemeToDark" withArguments:@[]];
    }else{
        [self.webView.windowScriptObject callWebScriptMethod:@"changeThemeToLight" withArguments:@[]];
    }
}

- (void)setupWebJSONViewer {
    if (self.webView) {
        self.webView.drawsBackground = NO;
        self.webView.frameLoadDelegate = self;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jsonviewer" ofType:@"html"];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        NSURLRequest *htmlRequest = [[NSURLRequest alloc] initWithURL:fileURL];
        [self.webView.mainFrame loadRequest:htmlRequest];
    }
}

- (void)renderJSONString {
    if (self.webView) {
        [self.webView.windowScriptObject callWebScriptMethod:@"renderJSONString" withArguments:@[self.jsonString ?: @""]];
    }
}

#pragma mark - WebFrameLoadDelegate methods
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    if (!self.isWebViewLoaded) {
        self.isWebViewLoaded = YES;
        [self renderJSONString];
    }
}
@end
