//
//  ECOPluginTableCellView.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/30. Maintain by 陈爱彬
//  Description 
//

#import "ECOPluginTableCellView.h"

@interface ECOPluginTableCellView()

@property (weak) IBOutlet NSBox *backgroundBox;
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSImageView *arrowImageView;
@property (weak) IBOutlet NSImageView *pluginImageView;
@property (weak) IBOutlet NSTextField *appLabel;
@property (weak) IBOutlet NSImageView *appIconImageView;
@property (weak) IBOutlet NSStackView *appInfoStackView;
@end
@implementation ECOPluginTableCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.appIconImageView.wantsLayer = YES;
    self.appIconImageView.layer.cornerRadius = 4.f;
}
- (void)refreshView {
    if (self.rootNode) {
        self.appInfoStackView.hidden = NO;
        if (self.showTriangle) {
            self.backgroundBox.hidden = YES;
        }else{
            self.backgroundBox.hidden = !self.isSelected;
        }
        self.arrowImageView.hidden = !self.showTriangle;
        self.titleLabel.hidden = YES;
        self.pluginImageView.hidden = YES;
        self.arrowImageView.image = self.isSelected ? [NSImage imageNamed:@"icon_arrow_down"] : [NSImage imageNamed:@"icon_arrow_up"];
        self.appLabel.stringValue = self.title ?: @"";
        if (self.appIcon && self.appIcon.length) {
            NSData *decodedImageData = [[NSData alloc]
                                        initWithBase64EncodedString:self.appIcon
                                        options:NSDataBase64DecodingIgnoreUnknownCharacters];
            self.appIconImageView.image = [[NSImage alloc] initWithData:decodedImageData];
        }else{
            self.appIconImageView.image = nil;
        }

    }else{
        self.backgroundBox.hidden = !self.isSelected;
        self.appInfoStackView.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.titleLabel.hidden = NO;
        self.pluginImageView.hidden = NO;
        self.pluginImageView.image = self.isSelected ? [NSImage imageNamed:self.pluginSelectedIcon ?: @""] : [NSImage imageNamed:self.pluginDefaultIcon ?: @""];
        self.titleLabel.textColor = self.isSelected ? [NSColor colorNamed:@"text_gray"] : [NSColor colorNamed:@"text_lightGray"];
        self.titleLabel.stringValue = self.title ?: @"";
    }
}

@end
