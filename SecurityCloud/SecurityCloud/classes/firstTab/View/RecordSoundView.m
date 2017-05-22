//
//  RecordSoundView.m
//  SecurityCloud
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "RecordSoundView.h"
#import <AVFoundation/AVFoundation.h>

# define COUNTDOWN 60
@interface RecordSoundView(){
    NSTimer *_timer; //定时器
    NSInteger count;  //倒计时
    NSString *filePath;
    NSString *noticeStr;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;


@property (nonatomic, strong) AVAudioSession *session;


@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器
@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址
@end
@implementation RecordSoundView
- (IBAction)bgClicked:(UIButton *)sender {
    [self removeFromSuperview];
}

-(RecordSoundView*)initWithFrame:(CGRect)frame RecordBlock:(RecordSoundViewBlock)block {
    RecordSoundView *recordSoundView = [[[NSBundle mainBundle] loadNibNamed:@"RecordSoundView" owner:nil options:nil] firstObject];
    recordSoundView.block = block;
    recordSoundView.frame = frame;
    return recordSoundView;
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    _recordButton.layer.masksToBounds = YES;
    _recordButton.layer.cornerRadius = _recordButton.frame.size.width;
    noticeStr = @"上滑取消";
    UILongPressGestureRecognizer *longPressG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressG.minimumPressDuration = 1;
    [_recordButton addGestureRecognizer:longPressG];
    
    UISwipeGestureRecognizer *swipG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    swipG.direction = UISwipeGestureRecognizerDirectionUp;
    [_recordButton addGestureRecognizer:swipG];
}

-(void)longPressed:(UILongPressGestureRecognizer*)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        [self start];
    }else if(ges.state == UIGestureRecognizerStateEnded){
        [self stop];
    }
    
}

-(void)swiped:(UISwipeGestureRecognizer*)ges {
    CGPoint location = [ges locationInView:_contentView];
    if ([self.recorder isRecording] && location.y < CGRectGetMinY(_recordButton.frame)) {
        noticeStr = @"松开取消";
    }
    
}

-(void)start {
    
    [self addTimer];
    
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if (session == nil) {
        
        NSLog(@"Error creating session: %@",[sessionError description]);
        
    }else{
        [session setActive:YES error:nil];
        
    }
    
    self.session = session;
    
    
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [path stringByAppendingString:@"/Record.wav"];
    
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:filePath];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    
    if (_recorder) {
        
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        //录音开始了
        
        /*
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self stop];
        });
        */
        
        
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }

}

-(void)stop {
    [self removeTimer];
    NSLog(@"停止录音");
    
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        _noticeLabel.text = [NSString stringWithFormat:@"录了 %ld 秒,文件大小为 %.2fKb",COUNTDOWN - (long)count,[[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0];
        
    }else{
        
        _noticeLabel.text = @"最多录60秒";
        
    }
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLabelText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
    
}


-(void)refreshLabelText{
    
    count++;
    
    _noticeLabel.text = [NSString stringWithFormat:@"%@ (%ld\")",noticeStr,(long)count];
    
    
}

@end
