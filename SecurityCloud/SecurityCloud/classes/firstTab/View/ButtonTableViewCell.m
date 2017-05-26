//
//  ButtonTableViewCell.m
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "ButtonTableViewCell.h"
#import "InfoDetailCellModel.h"
#import <AVFoundation/AVFoundation.h>
@interface ButtonTableViewCell()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *x_titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (nonatomic,strong) AVAudioPlayer *player;
@end
@implementation ButtonTableViewCell

- (IBAction)btnClicked:(UIButton *)sender {
    if (_model.showValue == nil) {
        [SVProgressHUD showErrorWithStatus:@"尚未录音"];
        return;
    }
    if (self.player) {
        sender.selected = !sender.selected;
        //播放 暂停
        if (!sender.selected) {
            //播放中 暂停
            [_player stop];
            
        }else{
            //开始播放
            [_player prepareToPlay];
            [_player play];
        }
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(InfoDetailCellModel *)model {
    _model = model;
    _x_titleLabel.text = _model.titleStr;
    if ([_model.showValue isEqualToString:@"null"]) {
        _btn.enabled = NO;
    }else{
        _btn.enabled = YES;
    }
}

-(AVAudioPlayer *)player {
    if (_player == nil) {
        NSError *playerError ;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.model.showValue] error:&playerError];
        _player.delegate = self;
        _player.volume = 1;
    }
    return _player;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    //播放结束
}

@end
