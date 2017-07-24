//
//  OfflineMembersTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 2017/7/19.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "OfflineMembersTableViewCell.h"
//#import "UserManager.h"
@interface OfflineMembersTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;


@end
@implementation OfflineMembersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(UserManager *)model{
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgurl] placeholderImage:PlaceHolderImage];
    _scoreLabel.text = [NSString stringWithFormat:@"%f",_model.jifen];
    _recentTimeLabel.text = [NSDate timeAgoSinceDate:[NSString dateForNSString:_model.time]];
    _nameLabel.text = _model.name;
    NSString *signStr = @"标签:";
    for (UserLabel *lb in _model.biaoqian2) {
        [signStr stringByAppendingString:lb.biaoti];
        [signStr stringByAppendingString:@" "];
    }
    
}

@end
