//
//  TagCollectionViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/28.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "TagCollectionViewCell.h"

@implementation TagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.8;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    // Initialization code
}

@end
