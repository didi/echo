//
//  YVRightCellViewInfo.m
//  YourView
//
//  Created by bliss_ddo on 2019/5/6.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVRightCellViewInfo.h"

@interface YVRightCellViewInfo()

@property (nonatomic, copy) NSDictionary *viewData;
@property (nonatomic, copy) NSDictionary *colorMap;
@property (nonatomic, copy) NSArray *basicColors;
@property (nonatomic, copy) NSArray *bgColors;
@property (nonatomic, copy) NSArray *borderColors;
@property (nonatomic, copy) NSArray *shadowColors;

@end

@implementation YVRightCellViewInfo

-(void)fillData:(NSDictionary*)data
{
    self.viewData = data;
    NSNumber *ecoHidden = data[@"isHidden"] ?: @(0);
    [self.hiddenBtn setState:[ecoHidden boolValue] ? NSControlStateValueOn : NSControlStateValueOff];
    NSNumber *ecoUserInteraction = data[@"userInter"] ?: @(0);
    [self.userInteractionBtn setState:[ecoUserInteraction boolValue] ? NSControlStateValueOn : NSControlStateValueOff];
    NSNumber *ecoMasksToBounds = data[@"masksTB"] ?: @(0);
    [self.masksTBBtn setState:[ecoMasksToBounds boolValue] ? NSControlStateValueOn : NSControlStateValueOff];
    NSString *ecoBgColor = data[@"bgColor"] ?: @"";
    NSString *bgDisplayColor = [self displayColorFromRGBA:ecoBgColor];
    [self.bgColorPopupBtn removeAllItems];
    if (bgDisplayColor.length &&
        ![self.basicColors containsObject:bgDisplayColor]) {
        NSMutableArray *list = [NSMutableArray arrayWithArray:self.basicColors];
        [list insertObject:bgDisplayColor atIndex:0];
        self.bgColors = [list copy];
    }else{
        self.bgColors = self.basicColors;
    }
    [self.bgColorPopupBtn addItemsWithTitles:self.bgColors];
    [self.bgColorPopupBtn selectItemWithTitle:bgDisplayColor ?: self.basicColors.firstObject];

    NSString *ecoBorderColor = data[@"bdColor"] ?: @"";
    NSString *borderDisplayColor = [self displayColorFromRGBA:ecoBorderColor];
    [self.borderPopupBtn removeAllItems];
    if (borderDisplayColor.length &&
        ![self.basicColors containsObject:borderDisplayColor]) {
        NSMutableArray *list = [NSMutableArray arrayWithArray:self.basicColors];
        [list insertObject:borderDisplayColor atIndex:0];
        self.borderColors = [list copy];
    }else{
        self.borderColors = self.basicColors;
    }
    [self.borderPopupBtn addItemsWithTitles:self.borderColors];
    [self.borderPopupBtn selectItemWithTitle:borderDisplayColor ?: self.basicColors.firstObject];

    NSNumber *ecoBorderWidth = data[@"bdWidth"] ?: @(0);
    self.borderWidthTextField.floatValue = [ecoBorderWidth floatValue];
    NSNumber *ecoCornerRadius = data[@"radius"] ?: @(0);
    self.radiusTextField.floatValue = [ecoCornerRadius floatValue];
    
    NSString *ecoShadowColor = data[@"sColor"] ?: @"";
    NSString *shadowDisplayColor = [self displayColorFromRGBA:ecoShadowColor];
    [self.shadowPopupBtn removeAllItems];
    if (shadowDisplayColor.length &&
        ![self.basicColors containsObject:shadowDisplayColor]) {
        NSMutableArray *list = [NSMutableArray arrayWithArray:self.basicColors];
        [list insertObject:shadowDisplayColor atIndex:0];
        self.shadowColors = [list copy];
    }else{
        self.shadowColors = self.basicColors;
    }
    [self.shadowPopupBtn addItemsWithTitles:self.shadowColors];
    [self.shadowPopupBtn selectItemWithTitle:shadowDisplayColor ?: self.basicColors.firstObject];

    NSNumber *ecoShadowOpacity = data[@"sOpacity"] ?: @(0);
    self.shadowOpaTextField.floatValue = [ecoShadowOpacity floatValue];
    NSNumber *ecoShadowRadius = data[@"sRadius"] ?: @(0);
    self.shadowRadiusTextField.floatValue = [ecoShadowRadius floatValue];
    NSNumber *ecoShadowOffsetW = data[@"sOffW"] ?: @(0);
    self.shadowOffsetWTextField.floatValue = [ecoShadowOffsetW floatValue];
    NSNumber *ecoShadowOffsetH = data[@"sOffH"] ?: @(0);
    self.shadowOffsetHTextField.floatValue = [ecoShadowOffsetH floatValue];
}

- (NSString *)displayColorFromRGBA:(NSString *)rgba {
    if ([rgba length]) {
        NSString *color = nil;
        NSArray *cComponents = [rgba componentsSeparatedByString:@","];
        if (cComponents.count == 4) {
            if ([cComponents[3] isEqualToString:@"1"]) {
                color = [NSString stringWithFormat:@"(%@,%@,%@)", cComponents[0],cComponents[1],cComponents[2]];
            }else{
                color = [NSString stringWithFormat:@"(%@,%@,%@,%@)", cComponents[0],cComponents[1],cComponents[2],cComponents[3]];
            }
        }else if (cComponents.count == 3) {
            color = [NSString stringWithFormat:@"(%@,%@,%@)", cComponents[0],cComponents[1],cComponents[2]];
        }
        NSString *displayColor = [self.colorMap objectForKey:color];
        return displayColor ?: color;
    }
    return nil;
}
- (NSString *)rgbaFromDisplayColor:(NSString *)color {
    if ([color hasSuffix:@")"]) {
        NSRange range = [color rangeOfString:@"("];
        NSString *c = [color substringFromIndex:range.location + 1];
        c = [c substringToIndex:c.length - 1];
        return c;
    }
    return @"";
}
#pragma mark - Actions
- (IBAction)onHiddenButtonValueChanged:(NSButton *)sender {
    BOOL isHidden = sender.state == NSControlStateValueOn;
    [self sendEditInfoWithSel:@"hidden" argv:@(isHidden)];
}
- (IBAction)onUserInteractionEnabledButtonValueChanged:(NSButton *)sender {
    BOOL isEnabled = sender.state == NSControlStateValueOn;
    [self sendEditInfoWithSel:@"userInteraction" argv:@(isEnabled)];
}
- (IBAction)onMasksToBoundsButtonValueChanged:(NSButton *)sender {
    BOOL isEnabled = sender.state == NSControlStateValueOn;
    [self sendEditInfoWithSel:@"maskToBounds" argv:@(isEnabled)];
}
- (IBAction)onAlphaTextFieldEdited:(NSTextField *)sender {
    //TODO:校验输入是否合法
    
    NSString *alpha = sender.stringValue;
    [self sendEditInfoWithSel:@"alpha" argv:alpha];
}
- (IBAction)onBackgroundColorChanged:(NSPopUpButton *)sender {
    NSString *bgColor = sender.titleOfSelectedItem;
    [self sendEditInfoWithSel:@"bgColor" argv:[self rgbaFromDisplayColor:bgColor]];
}
- (IBAction)onBorderColorChanged:(NSPopUpButton *)sender {
    NSString *borderColor = sender.titleOfSelectedItem;
    [self sendEditInfoWithSel:@"borderColor" argv:[self rgbaFromDisplayColor:borderColor]];
}
- (IBAction)onBorderWidthTextFieldEdited:(NSTextField *)sender {
    //TODO:校验输入是否合法
    
    NSString *borderWidth = sender.stringValue;
    [self sendEditInfoWithSel:@"borderWidth" argv:borderWidth];
}
- (IBAction)onCornerRadiusTextFieldEdited:(NSTextField *)sender {
    //TODO:校验输入是否合法
    
    NSString *cornerRadius = sender.stringValue;
    [self sendEditInfoWithSel:@"cornerRadius" argv:cornerRadius];
}
- (IBAction)onShadowColorChanged:(NSPopUpButton *)sender {
    NSString *shadowColor = sender.titleOfSelectedItem;
    [self sendEditInfoWithSel:@"shadowColor" argv:[self rgbaFromDisplayColor:shadowColor]];
}
- (IBAction)onShadowOpacityEdited:(NSTextField *)sender {
    //TODO:校验输入是否合法
    
    NSString *shadowOpacity = sender.stringValue;
    [self sendEditInfoWithSel:@"shadowOpacity" argv:shadowOpacity];
}
- (IBAction)onShadowRadiusEdited:(NSTextField *)sender {
    //TODO:校验输入是否合法
    
    NSString *shadowRadius = sender.stringValue;
    [self sendEditInfoWithSel:@"shadowRadius" argv:shadowRadius];
}
- (IBAction)onShadowOffsetWidthEdited:(NSTextField *)sender {
    //TODO:校验输入是否合法
    
    NSString *shadowOffsetW = sender.stringValue;
    [self sendEditInfoWithSel:@"shadowOffsetW" argv:shadowOffsetW];
}
- (IBAction)onShadowOffsetHeightEdited:(NSTextField *)sender {
    //TODO:校验输入是否合法
    
    NSString *shadowOffsetH = sender.stringValue;
    [self sendEditInfoWithSel:@"shadowOffsetH" argv:shadowOffsetH];
}

#pragma mark - helper
- (void)sendEditInfoWithSel:(NSString *)selString argv:(id)argv {
    if (!selString || ![selString length]) {
        return;
    }
    NSDictionary *info = @{
                           @"cmd": @"edit",
                           @"address": self.viewData[@"address"] ?: @"",
                           @"sel": selString,
                           @"argv": argv
                           };
    !self.editBlock ?: self.editBlock(info);
}
#pragma mark - getters
- (NSDictionary *)colorMap {
    if (!_colorMap) {
        _colorMap = @{
                      @"": @"Clear Color",
                      @"(0,0,0)": @"Black (0,0,0)",
                      @"(255,255,255)": @"White (255,255,255)",
                      @"(255,0,0)": @"Red (255,0,0)",
                      @"(0,0,255)": @"Blue (0,0,255)",
                      @"(0,255,0)": @"Green (0,255,0)",
                      @"(255,165,0)": @"Orange (255,165,0)"
                      };
    }
    return _colorMap;
}
- (NSArray *)basicColors {
    if (!_basicColors) {
        _basicColors = @[
                         @"Clear Color",
                         @"Black (0,0,0)",
                         @"White (255,255,255)",
                         @"Red (255,0,0)",
                         @"Blue (0,0,255)",
                         @"Green (0,255,0)",
                         @"Orange (255,165,0)"
                         ];
    }
    return _basicColors;
}
@end
