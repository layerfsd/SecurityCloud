//
//  PostedInfoTableViewCell.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/25.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "PostedInfoTableViewCell.h"
#import "PostModel.h"
@interface PostedInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleStrLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *operateImageView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation PostedInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(PostModel *)model {
    _model = model;
    if (_model.imgchakan.count > 0) {
        FileModel *imgModel = _model.imgchakan.firstObject;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imgModel.url]];
    }else{
         [_iconImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil];
    }
    
    if (![NSString isEmpty:_model.biaoti]) {
        _titleStrLabel.text = _model.biaoti;
    }else{
        _titleStrLabel.text = @"无标题，后台还未录入";
    }
    
    if (![NSString isEmpty:_model.neirongchakan]) {
        _contentLabel.text = _model.neirongchakan;
    }else{
        _contentLabel.text = @"用户很懒，什么都没有留下";
    }
    
    if (![NSString isEmpty:_model.jifen]) {
        _scoreLabel.text = [NSString stringWithFormat:@"积分:%@",_model.jifen];
    }else{
         _scoreLabel.text = @"还未处理，没有积分";
    }
    
    _timeLabel.text = [NSDate timeAgoSinceDate:[NSString dateForNSString:_model.time]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
