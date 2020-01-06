//
//  ECONetworkOverviewViewController.m
//  Echo
//
//  Created by 陈爱彬 on 2019/6/3. Maintain by 陈爱彬
//  Description 
//

#import "ECONetworkOverviewViewController.h"

@interface ECONetworkOverviewViewController ()
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation ECONetworkOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.textView.font = [NSFont systemFontOfSize:12];
}

- (void)setDetailInfo:(NSDictionary *)detailInfo {
    _detailInfo = detailInfo;
    __block NSString *overviewString = @"";
    if (_detailInfo) {
        //url
        NSString *method = _detailInfo[@"method"];
        NSString *url = _detailInfo[@"url"];
        overviewString = [overviewString stringByAppendingFormat:@"%@ %@\n\n",method, url];
        //status code
        NSString *code = _detailInfo[@"code"];
        overviewString = [overviewString stringByAppendingFormat:@"Status Code: %@\n\n", code];
        //headers
        overviewString = [overviewString stringByAppendingString:@"Request Headers:\n"];
        NSDictionary *headers = _detailInfo[@"headers"];
        [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            overviewString = [overviewString stringByAppendingFormat:@"%@：%@\n", key, obj];
        }];
        //querys
        overviewString = [overviewString stringByAppendingString:@"\n\nQuery String:\n"];
        NSDictionary *urlParams = _detailInfo[@"urlParams"];
        [urlParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            overviewString = [overviewString stringByAppendingFormat:@"%@：%@\n", key, obj];
        }];
        //response
        overviewString = [overviewString stringByAppendingString:@"\n\nResponse:\n"];
        id content = _detailInfo[@"content"];
        if ([content isKindOfClass:[NSDictionary class]] ||
            [content isKindOfClass:[NSArray class]]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:nil];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            overviewString = [overviewString stringByAppendingFormat:@"%@\n",responseString];
        }else if (content){
            overviewString = [overviewString stringByAppendingFormat:@"%@\n",content];
        }
    }
    self.textView.string = overviewString;
}

@end
