//
//  MoreMsgListTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/28.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MoreMsgListTableViewCell.h"
#import "MsgModel.h"
@implementation MoreMsgListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(MsgLitterModel *)model
{
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    _contentLabel.text = _model.biaoti;
    _timeLabel.text = [NSDate timeAgoSinceDate:[NSString dateForNSString:_model.time]];
}

@end
