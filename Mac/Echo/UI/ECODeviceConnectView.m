//
//  ECODeviceConnectView.m
//  Echo
//
//  Created by 陈爱彬 on 2019/9/24. Maintain by 陈爱彬
//  Description 
//

#import "ECODeviceConnectView.h"
#import <Masonry/Masonry.h>
#import "ECOPacketsDispatcher.h"

@interface ECODeviceConnectView()

@property (nonatomic, strong) NSImageView *tipImageView;
@property (nonatomic, strong) NSTextField *versionTipLabel;
@property (nonatomic, strong) NSTextField *nameTipLabel;
@property (nonatomic, strong) NSTextField *deviceTipLabel;
@property (nonatomic, strong) NSTextField *appTipLabel;
@property (nonatomic, strong) NSTextField *ipTipLabel;

@property (nonatomic, strong) NSTextField *tipLabel;
@property (nonatomic, strong) NSTextField *versionLabel;
@property (nonatomic, strong) NSTextField *nameLabel;
@property (nonatomic, strong) NSTextField *deviceLabel;
@property (nonatomic, strong) NSTextField *appLabel;
@property (nonatomic, strong) NSTextField *ipLabel;
@property (nonatomic, strong) NSBox *lineBox;

@property (nonatomic, strong) NSButton *connectButton;
@property (nonatomic, assign) BOOL isConnecting;

@end

@implementation ECODeviceConnectView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self.lineBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(1);
        }];
        [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(225);
            make.top.mas_equalTo(130);
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipImageView.mas_bottom).offset(30);
            make.centerX.mas_equalTo(self.tipImageView);
        }];
        [self.versionTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.tipImageView).offset(70);
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(18);
        }];
        [self.nameTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.tipImageView).offset(70);
            make.top.mas_equalTo(self.versionTipLabel.mas_bottom).offset(6);
        }];
        [self.deviceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.tipImageView).offset(70);
            make.top.mas_equalTo(self.nameTipLabel.mas_bottom).offset(6);
        }];
        [self.appTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.tipImageView).offset(70);
            make.top.mas_equalTo(self.deviceTipLabel.mas_bottom).offset(6);
        }];
        [self.ipTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.tipImageView).offset(70);
            make.top.mas_equalTo(self.appTipLabel.mas_bottom).offset(6);
        }];
        
        [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.tipImageView).offset(170);
            make.centerY.mas_equalTo(self.versionTipLabel);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.tipImageView).offset(170);
            make.centerY.mas_equalTo(self.nameTipLabel);
        }];
        [self.deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.tipImageView).offset(170);
            make.centerY.mas_equalTo(self.deviceTipLabel);
        }];
        [self.appLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.tipImageView).offset(170);
            make.centerY.mas_equalTo(self.appTipLabel);
        }];
        [self.ipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.tipImageView).offset(170);
            make.centerY.mas_equalTo(self.ipTipLabel);
        }];
        
        [self.connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.ipLabel.mas_bottom).offset(40);
            make.centerX.mas_equalTo(self.tipImageView);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)setProjectInfo:(ECOProjectModel *)projectInfo {
    _projectInfo = projectInfo;
    
    self.versionLabel.stringValue = _projectInfo.deviceInfo.systemVersion ?: @"";
    self.nameLabel.stringValue = _projectInfo.deviceInfo.deviceName ?: @"";
    self.deviceLabel.stringValue = _projectInfo.deviceInfo.deviceType == ECODeviceType_Simulator ? @"模拟器" : @"真机";
    NSString *hostIp = [ECOPacketsDispatcher shared].hostDevice.ipAddress;
    NSString *ipName = [hostIp isEqualToString:_projectInfo.deviceInfo.ipAddress] ? @"localhost" : _projectInfo.deviceInfo.ipAddress;
    self.ipLabel.stringValue = ipName ?: @"";
    self.appLabel.stringValue = [NSString stringWithFormat:@"%@ V%@(%@)", _projectInfo.deviceInfo.appInfo.appName ?: @"", _projectInfo.deviceInfo.appInfo.appShortVersion ?: @"", _projectInfo.deviceInfo.appInfo.appVersion ?: @""];
    self.isConnecting = _projectInfo.deviceInfo.showAuthAlert;
}

- (void)onConnectButtonTapped:(NSButton *)btn {
    if (self.isConnecting) {
        return;
    }
    self.isConnecting = YES;
    !self.connectBlock ?: self.connectBlock(self.projectInfo);
}

- (BOOL)isFlipped {
    return YES;
}

#pragma mark - setter
- (void)setIsConnecting:(BOOL)isConnecting {
    _isConnecting = isConnecting;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    if (_isConnecting) {
        _connectButton.layer.backgroundColor = [NSColor colorNamed:@"connect_btn_ing_color"].CGColor;
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"连接中..." attributes:@{NSForegroundColorAttributeName: [NSColor colorNamed:@"connect_title_color"], NSFontAttributeName: [NSFont boldSystemFontOfSize:12], NSParagraphStyleAttributeName: paragraphStyle}];
        [_connectButton setAttributedTitle:title];
    }else{
        _connectButton.layer.backgroundColor = [NSColor colorNamed:@"connect_btn_color"].CGColor;
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"连接" attributes:@{NSForegroundColorAttributeName: [NSColor colorNamed:@"connect_title_color"], NSFontAttributeName: [NSFont boldSystemFontOfSize:12], NSParagraphStyleAttributeName: paragraphStyle}];
        [_connectButton setAttributedTitle:title];
    }
}
#pragma mark - getter
- (NSImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [[NSImageView alloc] initWithFrame:NSZeroRect];
        _tipImageView.image = [NSImage imageNamed:@"device_connect_tip"];
        [self addSubview:_tipImageView];
    }
    return _tipImageView;
}

- (NSTextField *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _tipLabel.backgroundColor = [NSColor clearColor];
        _tipLabel.textColor = [NSColor colorNamed:@"text_black"];
        _tipLabel.font = [NSFont boldSystemFontOfSize:14];
        _tipLabel.bordered = NO;
        _tipLabel.editable = NO;
        _tipLabel.stringValue = @"当前App的信息";
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (NSTextField *)versionTipLabel {
    if (!_versionTipLabel) {
        _versionTipLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _versionTipLabel.backgroundColor = [NSColor clearColor];
        _versionTipLabel.textColor = [NSColor colorNamed:@"text_black"];
        _versionTipLabel.font = [NSFont boldSystemFontOfSize:13];
        _versionTipLabel.alignment = NSTextAlignmentRight;
        _versionTipLabel.bordered = NO;
        _versionTipLabel.editable = NO;
        _versionTipLabel.stringValue = @"系统版本号:";
        [self addSubview:_versionTipLabel];
    }
    return _versionTipLabel;
}

- (NSTextField *)nameTipLabel {
    if (!_nameTipLabel) {
        _nameTipLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _nameTipLabel.backgroundColor = [NSColor clearColor];
        _nameTipLabel.textColor = [NSColor colorNamed:@"text_black"];
        _nameTipLabel.font = [NSFont boldSystemFontOfSize:13];
        _nameTipLabel.alignment = NSTextAlignmentRight;
        _nameTipLabel.bordered = NO;
        _nameTipLabel.editable = NO;
        _nameTipLabel.stringValue = @"设备名:";
        [self addSubview:_nameTipLabel];
    }
    return _nameTipLabel;
}

- (NSTextField *)deviceTipLabel {
    if (!_deviceTipLabel) {
        _deviceTipLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _deviceTipLabel.backgroundColor = [NSColor clearColor];
        _deviceTipLabel.textColor = [NSColor colorNamed:@"text_black"];
        _deviceTipLabel.font = [NSFont boldSystemFontOfSize:13];
        _deviceTipLabel.alignment = NSTextAlignmentRight;
        _deviceTipLabel.bordered = NO;
        _deviceTipLabel.editable = NO;
        _deviceTipLabel.stringValue = @"类型:";
        [self addSubview:_deviceTipLabel];
    }
    return _deviceTipLabel;
}

- (NSTextField *)appTipLabel {
    if (!_appTipLabel) {
        _appTipLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _appTipLabel.backgroundColor = [NSColor clearColor];
        _appTipLabel.textColor = [NSColor colorNamed:@"text_black"];
        _appTipLabel.font = [NSFont boldSystemFontOfSize:13];
        _appTipLabel.alignment = NSTextAlignmentRight;
        _appTipLabel.bordered = NO;
        _appTipLabel.editable = NO;
        _appTipLabel.stringValue = @"App信息:";
        [self addSubview:_appTipLabel];
    }
    return _appTipLabel;
}
- (NSTextField *)ipTipLabel {
    if (!_ipTipLabel) {
        _ipTipLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _ipTipLabel.backgroundColor = [NSColor clearColor];
        _ipTipLabel.textColor = [NSColor colorNamed:@"text_black"];
        _ipTipLabel.font = [NSFont boldSystemFontOfSize:13];
        _ipTipLabel.alignment = NSTextAlignmentRight;
        _ipTipLabel.bordered = NO;
        _ipTipLabel.editable = NO;
        _ipTipLabel.stringValue = @"IP地址:";
        [self addSubview:_ipTipLabel];
    }
    return _ipTipLabel;
}


- (NSTextField *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _versionLabel.backgroundColor = [NSColor clearColor];
        _versionLabel.textColor = [NSColor colorNamed:@"text_lightGray"];
        _versionLabel.font = [NSFont systemFontOfSize:13];
        _versionLabel.bordered = NO;
        _versionLabel.editable = NO;
        [self addSubview:_versionLabel];
    }
    return _versionLabel;
}

- (NSTextField *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _nameLabel.backgroundColor = [NSColor clearColor];
        _nameLabel.textColor = [NSColor colorNamed:@"text_lightGray"];
        _nameLabel.font = [NSFont systemFontOfSize:13];
        _nameLabel.bordered = NO;
        _nameLabel.editable = NO;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (NSTextField *)deviceLabel {
    if (!_deviceLabel) {
        _deviceLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _deviceLabel.backgroundColor = [NSColor clearColor];
        _deviceLabel.textColor = [NSColor colorNamed:@"text_lightGray"];
        _deviceLabel.font = [NSFont systemFontOfSize:13];
        _deviceLabel.bordered = NO;
        _deviceLabel.editable = NO;
        [self addSubview:_deviceLabel];
    }
    return _deviceLabel;
}

- (NSTextField *)appLabel {
    if (!_appLabel) {
        _appLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _appLabel.backgroundColor = [NSColor clearColor];
        _appLabel.textColor = [NSColor colorNamed:@"text_lightGray"];
        _appLabel.font = [NSFont systemFontOfSize:13];
        _appLabel.bordered = NO;
        _appLabel.editable = NO;
        [self addSubview:_appLabel];
    }
    return _appLabel;
}

- (NSTextField *)ipLabel {
    if (!_ipLabel) {
        _ipLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        _ipLabel.backgroundColor = [NSColor clearColor];
        _ipLabel.textColor = [NSColor colorNamed:@"text_lightGray"];
        _ipLabel.font = [NSFont systemFontOfSize:13];
        _ipLabel.bordered = NO;
        _ipLabel.editable = NO;
        [self addSubview:_ipLabel];
    }
    return _ipLabel;
}

- (NSButton *)connectButton {
    if (!_connectButton) {
        _connectButton = [[NSButton alloc] initWithFrame:NSZeroRect];
        _connectButton.wantsLayer = YES;
        _connectButton.layer.backgroundColor = [NSColor colorNamed:@"connect_btn_color"].CGColor;
        _connectButton.layer.cornerRadius = 2.5f;
        _connectButton.layer.shadowColor = [NSColor colorWithWhite:0 alpha:0.06].CGColor;
        _connectButton.layer.shadowOffset = CGSizeMake(0, 3);
        _connectButton.layer.shadowRadius = 0.06;
        _connectButton.layer.shadowOpacity = 1;
        _connectButton.bordered = NO;
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"连接" attributes:@{NSForegroundColorAttributeName: [NSColor colorNamed:@"connect_title_color"], NSFontAttributeName: [NSFont boldSystemFontOfSize:12]}];
        [_connectButton setAttributedTitle:title];
        [_connectButton setTarget:self];
        [_connectButton setAction:@selector(onConnectButtonTapped:)];
        [self addSubview:_connectButton];
    }
    return _connectButton;
}

- (NSBox *)lineBox {
    if (!_lineBox) {
        _lineBox = [[NSBox alloc] init];
        _lineBox.boxType = NSBoxCustom;
        _lineBox.borderWidth = 0;
        _lineBox.cornerRadius = 0;
        _lineBox.fillColor = [NSColor colorNamed:@"connect_line_color"];
        [self addSubview:_lineBox];
    }
    return _lineBox;
}

@end
