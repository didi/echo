//
//  ECODeviceTableCellView.m
//  Echo
//
//  Created by 陈爱彬 on 2019/5/15. Maintain by 陈爱彬
//  Description 
//

#import "ECODeviceTableCellView.h"
#import <Masonry/Masonry.h>

@interface ECODeviceTableCellView()
@property (weak) IBOutlet NSBox *dotView;
@property (weak) IBOutlet NSImageView *deviceTypeImageView;
@property (weak) IBOutlet NSTextField *deviceTypeLabel;
@property (weak) IBOutlet NSImageView *deviceStatusImageView;
@property (weak) IBOutlet NSTextField *deviceLabel;

@end

@implementation ECODeviceTableCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.deviceStatusImageView.mas_trailing).offset(10);
        make.centerY.mas_equalTo(self);
        make.trailing.mas_equalTo(10);
    }];
}

- (void)refreshView {
    if (!self.isDevice) {
        self.dotView.hidden = NO;
        self.deviceTypeImageView.hidden = NO;
        self.deviceTypeLabel.hidden = NO;
        self.deviceLabel.hidden = YES;
        self.deviceStatusImageView.hidden = YES;
        self.deviceTypeImageView.image = self.isAuthorized ? [NSImage imageNamed:@"device_authed"] : [NSImage imageNamed:@"device_unAuthed"];
        self.dotView.fillColor = self.isAuthorized ? [NSColor colorNamed:@"dot_default"] : [NSColor colorNamed:@"dot_red"];
        self.deviceTypeLabel.stringValue = self.deviceName ?: @"";
    }else{
        self.dotView.hidden = YES;
        self.deviceTypeImageView.hidden = YES;
        self.deviceTypeLabel.hidden = YES;
        self.deviceLabel.hidden = NO;
        self.deviceStatusImageView.hidden = NO;
        
        //设备
        self.deviceStatusImageView.image = self.isConnected ? [NSImage imageNamed:@"device_connected"] : [NSImage imageNamed:@"device_disConnected"];
        self.deviceLabel.textColor = self.isConnected ? [NSColor colorNamed:@"text_lightBlack"] : [NSColor colorNamed:@"text_lightGray"];
        self.deviceLabel.stringValue = self.deviceName ?: @"";

        if (self.isSelected) {
            [self.deviceStatusImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(50);
                make.centerY.mas_equalTo(self);
                make.width.height.mas_equalTo(13);
            }];
        }else{
            [self.deviceStatusImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(30);
                make.centerY.mas_equalTo(self);
                make.width.height.mas_equalTo(13);
            }];
        }
    }
}
@end
