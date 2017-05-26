//
//  ImagesTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "ImagesTableViewCell.h"
#import "InfoDetailCellModel.h"
#import "ImageCollectionViewCell.h"
#define column 3
@interface ImagesTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *x_titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@end
@implementation ImagesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat cellW = (kScreenWidth - _x_titleLabel.frame.size.width - 30 - (column - 1)*10)/column;
    _flowLayout.itemSize = CGSizeMake(cellW, cellW);
    NSInteger row = ([_model.showValue count] - 1)/column + 1;
    _collectionViewHeightConstraint.constant = row * cellW + (row - 1)*10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(InfoDetailCellModel *)model {
    _model = model;
    _x_titleLabel.text = _model.titleStr;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([_model.showValue isKindOfClass:[NSArray class]]) {
        return [_model.showValue count];
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    cell.imageUrl = _model.showValue[indexPath.item];
    return cell;
}




@end
