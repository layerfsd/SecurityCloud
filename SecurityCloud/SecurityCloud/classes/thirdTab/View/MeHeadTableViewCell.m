//
//  MeHeadTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MeHeadTableViewCell.h"
#import "UserModel.h"
@interface MeHeadTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeButton;

@end
@implementation MeHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)qRCodeAction:(UIButton *)sender {
}

-(void)setModel:(UserModel *)model {
    _model = model;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil];
    _nameLabel.text = _model.name;
    _scoreLabel.text = @"积分：11.02分";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
