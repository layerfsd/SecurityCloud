//
//  DraftBoxTableViewCell.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/25.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "DraftBoxTableViewCell.h"
#import "Info+CoreDataClass.h"
#import "ImageModel+CoreDataClass.h"
#import <AVFoundation/AVFoundation.h>
@interface DraftBoxTableViewCell()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong) AVAudioPlayer *player;

@end

@implementation DraftBoxTableViewCell
- (IBAction)recordBegin:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(deleteCell:)]) {
        [_delegate deleteCell:self.tag];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(Info *)model {
    _model = model;
    NSLog(@"%@",model.voicePath);
    
    if (![NSString isEmpty:_model.images]) {
        NSArray<NSString*> *imageNames = [_model.images componentsSeparatedByString:@","];
        ImageModel *imageModel = [ImageModel MR_findByAttribute:@"imageName" withValue:imageNames.firstObject].firstObject;
        UIImage *image = [UIImage imageWithData:imageModel.imageData];

        _iconImageVIew.image = image;
    }else{
        _iconImageVIew.image = [UIImage imageNamed:@"placeholderImage"];
    }
    
    if (![NSString isEmpty:_model.content]) {
        _contentLabel.text = _model.content;
    }else{
        _contentLabel.text = @"这个家伙很懒，什么都没留下";
    }
    
//    if (_model.voicePath) {
//        NSError *playerError ;
//        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_model.voicePath] error:&playerError];
//        _player.delegate = self;
//        _player.volume = 1;
//    }else{
//        _player = nil;
//    }
    _timeLabel.text = [NSDate timeAgoSinceDate:_model.creatTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
