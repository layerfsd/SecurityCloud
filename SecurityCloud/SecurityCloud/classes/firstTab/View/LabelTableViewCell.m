//
//  LabelTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "LabelTableViewCell.h"
#import "InfoDetailCellModel.h"
@interface LabelTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *x_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation LabelTableViewCell

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
    _contentLabel.text = _model.showValue;
}

@end
