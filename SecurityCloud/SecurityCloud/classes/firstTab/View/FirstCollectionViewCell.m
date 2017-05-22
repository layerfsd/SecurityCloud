//
//  FirstCollectionViewCell.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/22.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "FirstCollectionViewCell.h"
#import "FirstTabCellModel.h"
@interface FirstCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *x_titleLabel;

@end

@implementation FirstCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(FirstTabCellModel *)model {
    _model = model;
    _x_titleLabel.text = model.titleStr;
    _imageView.image = [UIImage imageNamed:model.imageName];
}

@end
