//
//  ECOTemplateH5ViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/8/6. Maintain by 陈爱彬
//  Description 
//

#import "ECOTemplateH5ViewController.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"

typedef void(^ECOJSBridgeBlock)(void);

static NSString *const EchoJSBridgeName = @"echoSend";
static NSString *const EchoJSReceivedBridgeName = @"echoJSReceived";

@interface ECOTemplateH5ViewController ()
<WKScriptMessageHandler, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) ECOJSBridgeBlock echoBlock;
@property (nonatomic, copy) NSArray *h5Packets;
@property (nonatomic, assign) NSInteger evalIndex;

@end

@implementation ECOTemplateH5ViewController

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.evalIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [WKUserContentController new];
    [config.userContentController addScriptMessageHandler:self name:EchoJSBridgeName];

    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    self.webView.wantsLayer = YES;
    self.webView.layer.cornerRadius = 15;
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(16);
        make.bottom.trailing.mas_equalTo(-16);
    }];
}

#pragma mark - ECOPluginUIProtocol methods
- (void)refreshWithPackets:(NSArray *)packets {
    if ([self.h5Packets isEqualToArray:packets]) {
        return;
    }
    self.h5Packets = packets;
    //如果当前H5还未渲染到最新，找到最后一个html数据渲染
    NSInteger lastHtml = -1;
    for (NSInteger i = self.h5Packets.count - 1; i >= 0; i--) {
        NSDictionary *item = self.h5Packets[i];
        NSString *html = item[@"html"];
        if (html && html.length) {
            lastHtml = i;
            break;
        }
    }
    if (self.evalIndex < lastHtml) {
        self.evalIndex = lastHtml;
    }
    if (self.evalIndex == -1 ||
        self.evalIndex >= self.h5Packets.count) {
        return;
    }
    NSDictionary *item = self.h5Packets[self.evalIndex];
    self.evalIndex += 1;
    NSString *htmlString = item[@"html"];
    if (htmlString && htmlString.length) {
        //展示HTML
        NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"echoJS" ofType:@"js"];
        NSURL *baseURL = [NSURL fileURLWithPath:jsPath];
        [self.webView loadHTMLString:htmlString baseURL:baseURL];
    }else {
        //发送Native数据到JS
        id params = item[@"jsParams"];
        [self callJSMethod:params];
    }
}

#pragma mark - JS调用
- (void)callJSMethod:(id)params {
    if ([params isKindOfClass:[NSString class]]) {
        params = [[NSString alloc] initWithFormat:@"'%@'", params];
    }
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"echoReceived(%@)", params] completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        
    }];
}

- (void)receivedJSMessage:(id)result {
    if (!result) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:result forKey:@"jsResult"];
    !self.plugin.sendBlock ?: self.plugin.sendBlock(dict);
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"name:%@",message.name);
    NSLog(@"body:%@",message.body);
    if ([message.name isEqualToString:EchoJSBridgeName]) {
        [self receivedJSMessage:message.body];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    for (NSInteger i = self.evalIndex; i < self.h5Packets.count; i++) {
        NSDictionary *item = self.h5Packets[i];
        id params = item[@"jsParams"];
        [self callJSMethod:params];
    }
    self.evalIndex = self.h5Packets.count;
}

@end
