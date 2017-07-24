//
//  RankingTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/30.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "RankingTableViewCell.h"
#import "UserModel.h"
@implementation RankingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(UserModel *)model {
    _model = model;
    _userNameLabel.text = _model.name == nil ? @"无用户名":_model.name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    _scoreLabel.text = _model.tj == nil ? @"0分":[NSString stringWithFormat:@"%@分",_model.tj];
}

@end
