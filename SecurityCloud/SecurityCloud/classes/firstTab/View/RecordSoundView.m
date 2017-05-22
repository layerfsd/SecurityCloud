//
//  RecordSoundView.m
//  SecurityCloud
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "RecordSoundView.h"
#import <AVFoundation/AVFoundation.h>

# define COUNTDOWN 60.0
@interface RecordSoundView(){
    NSTimer *_timer; //定时器
    NSInteger count;  //倒计时
    NSString *filePath;
    NSString *noticeStr;
    //区别秒
    NSInteger allCount;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic,strong) CAShapeLayer *bgLayer;
@property (weak, nonatomic) IBOutlet UIView *subContentView;

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
    _recordButton.layer.cornerRadius = _recordButton.frame.size.width * 0.5;
    _recordButton.layer.borderColor = [[UIColor grayColor] CGColor];
    _recordButton.layer.borderWidth = 0.8;
    noticeStr = @"点击按钮开始录音";
    UILongPressGestureRecognizer *longPressG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressG.minimumPressDuration = 0.5;
    [_recordButton addGestureRecognizer:longPressG];
    _subContentView.layer.masksToBounds = YES;

}

-(void)longPressed:(UILongPressGestureRecognizer*)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        [self start];
    }else if(ges.state == UIGestureRecognizerStateEnded){
        if ([noticeStr isEqualToString:@"松开取消"]) {
            //移除
            [self cancel];
        }else{
            [self stop];
        }
        
    }else if(ges.state == UIGestureRecognizerStateChanged){
        CGPoint location = [ges locationInView:_contentView];
        if ([self.recorder isRecording] && location.y < CGRectGetMinY(_recordButton.frame)) {
            //需要改变按钮颜色
            _recordButton.backgroundColor = [UIColor redColor];
            noticeStr = @"松开取消";
        }else{
            _recordButton.backgroundColor = [UIColor whiteColor];
            noticeStr = @"上滑取消";
        }
    }else{
        
    }
    
}



-(void)start {
    [_subContentView.layer insertSublayer:self.bgLayer below:_recordButton.layer];
    
    [self addTimer];
    noticeStr = @"上滑取消";
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
    _progressView.progress = 0;
    [self.bgLayer removeFromSuperlayer];
    
    [self removeTimer];
   
    
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        _noticeLabel.text = [NSString stringWithFormat:@"录了 %ld 秒,文件大小为 %.2fKb",(long)count,[[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0];
        
    }else{
        
        _noticeLabel.text = @"最多录60秒";
        
    }
    _recordButton.backgroundColor = [UIColor whiteColor];
}

-(void)cancel{
    _progressView.progress = 0;
    [self.bgLayer removeFromSuperlayer];
    
    [self removeTimer];
   
    noticeStr = @"长按钮开始录音";
    _noticeLabel.text = [NSString stringWithFormat:@"%@",noticeStr];
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        [manager removeItemAtPath:filePath error:nil];
        
    }else{
        
        _noticeLabel.text = @"最多录60秒";
        
    }
    _recordButton.backgroundColor = [UIColor whiteColor];
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshLabelText) userInfo:nil repeats:YES];
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
    if (count >= COUNTDOWN) {
        [self stop];
    }
    
    allCount = allCount + 1;
    
    
    if (allCount % 10 == 0) {
        //一秒一次
        count++;
        _noticeLabel.text = [NSString stringWithFormat:@"%@ (%ld\")",noticeStr,(long)count];
        
        CGFloat progre = count / COUNTDOWN;
        
        _progressView.progress = progre;

        
    }else{
        //更新音量
        [_recorder updateMeters];
        
        float   level;                // The linear 0.0 .. 1.0 value we need.
        float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
        float   decibels    = [_recorder averagePowerForChannel:0];
        
        if (decibels < minDecibels)
        {
            level = 0.0f;
        }
        else if (decibels >= 0.0f)
        {
            level = 1.0f;
        }
        else
        {
            float   root            = 2.0f;
            float   minAmp          = powf(10.0f, 0.05f * minDecibels);
            float   inverseAmpRange = 1.0f / (1.0f - minAmp);
            float   amp             = powf(10.0f, 0.05f * decibels);
            float   adjAmp          = (amp - minAmp) * inverseAmpRange;
            
            level = powf(adjAmp, 1.0f / root);
        }
        CGFloat radius = _recordButton.frame.size.width * 0.5 + (_contentView.frame.size.width - _recordButton.frame.size.width) * 0.5 * level;
        [self path:radius];
    }
    
   
    
   
    
    
   
    
}

-(void)path:(CGFloat)radius {
    CGPoint suCenter = CGPointMake(_recordButton.frame.size.width * 0.5,_recordButton.frame.size.width * 0.5);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:suCenter radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    self.bgLayer.path = [path CGPath];
}



-(CAShapeLayer *)bgLayer {
    if (_bgLayer == nil) {
        _bgLayer = [CAShapeLayer new];
        
        _bgLayer.frame = CGRectOffset(_recordButton.frame,0,0);
        
        _bgLayer.fillColor = [[UIColor grayColor] CGColor];
        
    }
    return _bgLayer;
}

@end
