//
//  ImageCollectionViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "ImageCollectionViewCell.h"
@interface ImageCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;

@end
@implementation ImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_imageVIew sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}

@end
