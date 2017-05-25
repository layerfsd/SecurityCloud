//
//  MeTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MeTableViewCell.h"
#import "MeCellData.h"
@interface MeTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleStrLabel;


@end
@implementation MeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(MeCellData *)model {
    _model = model;
    _iconImageView.image = [UIImage imageNamed:_model.imageName];
    _titleStrLabel.text = _model.titleStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
