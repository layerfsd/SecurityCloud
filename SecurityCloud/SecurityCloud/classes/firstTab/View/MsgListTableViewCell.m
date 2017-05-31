//
//  MsgListTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/30.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MsgListTableViewCell.h"
#import "MsgCenterModel.h"
@implementation MsgListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(MsgCenterModel *)model {
    _model = model;
    _iconButton.selected = [_model.zhuangtai integerValue] == 1?YES:NO;
    _timeLabel.text = _model.time;
    _contentLabel.text = _model.biaoti;
}

@end
