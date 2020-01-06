//
//  ECOViewBorderPlugin.m
//  EchoSDK
//
//  Created by zhanghe on 2019/8/28.
//

#import "ECOViewBorderPlugin.h"
#import "EchoSDKDefines.h"
#import "ECOClient.h"
#import "ECOViewBorderInspector.h"

@implementation ECOViewBorderPlugin

+ (void)load {
    [[ECOClient sharedClient] registerPlugin:[self class]];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"视图边框线";
        [self registerTemplate:ECOUITemplateType_H5 data:nil];
        [ECOViewBorderInspector sharedInstance];
    }
    return self;
}

- (void)device:(ECOChannelDeviceInfo *)device didChangedAuthState:(BOOL)isAuthed {
    if (isAuthed) {
        NSString *htmlPath = [EchoBundle pathForResource:@"ECOViewBorder" ofType:@"html"];
        if (!htmlPath) {
            return;
        }
        NSURL *fileURL = [NSURL fileURLWithPath:htmlPath];
        NSString *htmlString = [[NSString alloc] initWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
        if (htmlString && [htmlString length]) {
            !self.deviceSendBlock ?: self.deviceSendBlock(device, @{EchoHTMLKey: htmlString});
        }
        !self.deviceSendBlock ?: self.deviceSendBlock(device, @{EchoJSParams: @([ECOViewBorderInspector sharedInstance].showViewBorder)});
    }
}

- (void)didReceivedPacketData:(id)data fromDevice:(ECOChannelDeviceInfo *)device {
    NSDictionary *dict = (NSDictionary *)data;
    NSNumber *result = dict[EchoJSResult];
    [[ECOViewBorderInspector sharedInstance] setShowViewBorder:[result boolValue]];
}

@end
