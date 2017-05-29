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
@interface ImagesTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,ESPictureBrowserDelegate>
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ESPictureBrowser *browser = [[ESPictureBrowser alloc] init];
    browser.delegate = self;
    [browser showFromView:self picturesCount:[_model.showValue count] currentPictureIndex:indexPath.item];
}


- (UIView *)pictureView:(ESPictureBrowser *)pictureBrowser viewForIndex:(NSInteger)index{
    return self;
}
/**
 获取对应索引的图片大小
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片大小
 */
- (CGSize)pictureView:(ESPictureBrowser *)pictureBrowser imageSizeForIndex:(NSInteger)index {
     CGFloat cellW = (kScreenWidth - _x_titleLabel.frame.size.width - 30 - (column - 1)*10)/column;
    return CGSizeMake(cellW, cellW);
}

/**
 获取对应索引默认图片，可以是占位图片，可以是缩略图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片
 */
- (UIImage *)pictureView:(ESPictureBrowser *)pictureBrowser defaultImageForIndex:(NSInteger)index {
    return [UIImage imageNamed:@""];
}

/**
 获取对应索引的高质量图片地址字符串
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片的 url 字符串
 */
- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    return _model.showValue[index];
}


@end
