//
//  CirclePostMessageCollectionViewCell.m
//  TodaySoft
//
//  Created by hsgene_xu on 2017/3/9.
//  Copyright © 2017年 haoyee. All rights reserved.
//

#import "CirclePostMessageCollectionViewCell.h"
@interface CirclePostMessageCollectionViewCell()
@end
@implementation CirclePostMessageCollectionViewCell
- (IBAction)cancelClicked:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(cancelImage:)]) {
        [_delegate cancelImage:sender.tag];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
