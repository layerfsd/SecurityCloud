//
//  AdoptedTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "AdoptedTableViewCell.h"
#import "InfoDetailCellModel.h"
@interface AdoptedTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *x_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation AdoptedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(InfoDetailCellModel *)model{
    _model = model;
    _x_titleLabel.text = _model.titleStr;
    _scoreLabel.text = _model.showValue;
    _timeLabel.text = _model.moreValue;
}

@end
