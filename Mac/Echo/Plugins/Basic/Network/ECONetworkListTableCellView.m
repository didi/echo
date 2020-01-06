//
//  ECONetworkListTableCellView.m
//  Echo
//
//  Created by 陈爱彬 on 2019/9/29. Maintain by 陈爱彬
//  Description 
//

#import "ECONetworkListTableCellView.h"


@interface ECONetworkListTableCellView()

@property (weak) IBOutlet NSBox *bgBox;
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSBox *lineView;

@end

@implementation ECONetworkListTableCellView

- (void)setContent:(NSString *)content {
    _content = content;
    self.titleLabel.stringValue = _content ?: @"";
}

- (void)setIsCellSelected:(BOOL)isCellSelected {
    _isCellSelected = isCellSelected;
    self.bgBox.hidden = !_isCellSelected;
}
@end
