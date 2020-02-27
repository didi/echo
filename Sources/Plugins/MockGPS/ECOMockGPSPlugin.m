//
//  ECOMockGPSPlugin.m
//  EchoSDK
//
//  Created by 陈爱彬 on 2019/8/6. Maintain by 陈爱彬
//  Description 
//

#import "ECOMockGPSPlugin.h"
#import "EchoSDKDefines.h"
#import "ECOClient.h"
#import "ECOMockGPSManager.h"

#import <JZLocationConverter/JZLocationConverter.h>

@implementation ECOMockGPSPlugin

+ (void)load {
    [[ECOClient sharedClient] registerPlugin:[self class]];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"模拟定位";
        [self registerTemplate:ECOUITemplateType_H5 data:nil];
        [ECOMockGPSManager sharedInstance];
    }
    return self;
}

- (void)device:(ECOChannelDeviceInfo *)device didChangedAuthState:(BOOL)isAuthed {
    if (isAuthed) {
        NSString *htmlPath = [EchoBundle pathForResource:@"ECOMockGPS" ofType:@"html"];
        if (!htmlPath) {
            return;
        }
        NSURL *fileURL = [NSURL fileURLWithPath:htmlPath];
        NSString *htmlString = [[NSString alloc] initWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
        if (htmlString && [htmlString length]) {
            !self.deviceSendBlock ?: self.deviceSendBlock(device, @{EchoHTMLKey: htmlString});
        }
    }
}

- (void)didReceivedPacketData:(id)data fromDevice:(ECOChannelDeviceInfo *)device {
    NSDictionary *dict = (NSDictionary *)data;
    NSString *result = dict[EchoJSResult];
    NSArray *locationArr = [result componentsSeparatedByString:@","];
    if (locationArr.count == 2) {
        NSString *lat = locationArr[1];
        NSString *lng = locationArr[0];
        CLLocationCoordinate2D gcj = CLLocationCoordinate2DMake(lat.doubleValue, lng.doubleValue);
        CLLocationCoordinate2D wgs = [JZLocationConverter gcj02ToWgs84:gcj];
        
        CLLocation *locationWgs = [[CLLocation alloc] initWithLatitude:wgs.latitude longitude:wgs.longitude];
        [[ECOMockGPSManager sharedInstance] mockLocation:locationWgs];
        !self.deviceSendBlock ?: self.deviceSendBlock(device, @{EchoJSParams: @"定位成功"});
    } else {
        !self.deviceSendBlock ?: self.deviceSendBlock(device, @{EchoJSParams: @"定位失败"});
    }
}

@end
