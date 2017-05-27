//
//  LableOnlyTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "LableOnlyTableViewCell.h"
#import "InfoDetailCellModel.h"
@interface LableOnlyTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *x_titleLabel;

@end
@implementation LableOnlyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(PersonDetailCellModel *)model{
    _model = model;
    _x_titleLabel.text = _model.titleStr;
}

@end
