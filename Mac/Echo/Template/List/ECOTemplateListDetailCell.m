//
//  ECOTemplateListDetailCell.m
//  Echo
//
//  Created by 陈爱彬 on 2019/8/15. Maintain by 陈爱彬
//  Description 
//

#import "ECOTemplateListDetailCell.h"
#import <Masonry/Masonry.h>

@interface ECOTemplateListDetailCell()

@property (nonatomic, strong) NSBox *bgBox;
@property (nonatomic, strong) NSTextField *titleLabel;
@property (nonatomic, strong) NSBox *lineBox;

@end

@implementation ECOTemplateListDetailCell

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self.bgBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_equalTo(0);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(10);
            make.trailing.mas_equalTo(0);
            make.centerY.mas_equalTo(self);
        }];
        [self.lineBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(0);
            //            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.stringValue = _title ?: @"";
}

- (void)setSelectedMark:(BOOL)selectedMark {
    _selectedMark = selectedMark;
    self.bgBox.hidden = !_selectedMark;
}

- (NSLineBreakMode)titleLineBreak {
    return self.titleLabel.cell.lineBreakMode;
}
- (void)setTitleLineBreak:(NSLineBreakMode)titleLineBreak {
    self.titleLabel.cell.lineBreakMode = titleLineBreak;
}

#pragma mark - getters
- (NSBox *)bgBox {
    if (!_bgBox) {
        _bgBox = [[NSBox alloc] initWithFrame:self.bounds];
        _bgBox.boxType = NSBoxCustom;
        _bgBox.cornerRadius = 0.f;
        _bgBox.borderColor = [NSColor clearColor];
        _bgBox.borderWidth = 0.f;
        _bgBox.fillColor = [NSColor colorNamed:@"listDetail_cellSelection"];
        [self addSubview:_bgBox];
        _bgBox.hidden = YES;
    }
    return _bgBox;
}
- (NSTextField *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[NSTextField alloc] init];
        _titleLabel.backgroundColor = [NSColor clearColor];
        _titleLabel.bordered = NO;
        _titleLabel.textColor = [NSColor colorNamed:@"listDetail_text"];
        _titleLabel.editable = NO;
        _titleLabel.maximumNumberOfLines = 1;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (NSBox *)lineBox {
    if (!_lineBox) {
        _lineBox = [[NSBox alloc] initWithFrame:CGRectMake(0, 0, 100, 0.5)];
        _lineBox.boxType = NSBoxCustom;
        _lineBox.fillColor = [NSColor colorNamed:@"listDetail_line"];
        _lineBox.cornerRadius = 0.f;
        _lineBox.borderColor = [NSColor clearColor];
        _lineBox.borderWidth = 0.f;
        [self addSubview:_lineBox];
    }
    return _lineBox;
}

@end
