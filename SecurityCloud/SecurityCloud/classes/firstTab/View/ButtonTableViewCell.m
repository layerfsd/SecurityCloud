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
    
    sender.selected = !sender.selected;
        //播放 暂停
    if (!sender.selected) {
            //播放中 暂停
        [_player stop];
            
    }else{
            //开始播放
        [self play];
    }


}

-(void)play {
    NSString *urlStr = self.model.showValue;
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    
    //将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.wav", docDirPath , @"temp"];
    [audioData writeToFile:filePath atomically:YES];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    NSError *playerError ;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&playerError];
    _player.delegate = self;
    _player.volume = 1;
    [_player prepareToPlay];
    [_player play];
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
    if ([_model.showValue isEqualToString:@"null"]||_model.showValue == nil) {
        _btn.enabled = NO;
    }else{
        _btn.enabled = YES;
    }
}



-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    //播放结束
    _btn.selected = NO;
}

@end
