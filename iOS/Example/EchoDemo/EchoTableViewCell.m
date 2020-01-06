//
//  EchoTableViewCell.m
//  EchoDemo
//
//  Created by 陈爱彬 on 2019/11/28. Maintain by 陈爱彬
//  Description 
//

#import "EchoTableViewCell.h"

@interface EchoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *ecoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ecoDetailLabel;
@end

@implementation EchoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContent:(NSDictionary *)content {
    _content = content;
    NSString *title = _content[@"title"];
    self.ecoTitleLabel.text = title;
    NSString *detail = _content[@"detail"];
    self.ecoDetailLabel.text = detail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
