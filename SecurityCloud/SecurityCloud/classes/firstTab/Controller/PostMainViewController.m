//
//  PostMainViewController.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/22.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "PostMainViewController.h"
#import "PostModel.h"
#import "CirclePostMessageCollectionViewCell.h"
#import "RecordSoundView.h"
#import <AVFoundation/AVFoundation.h>

#define colum 5
#define cellWidth (kScreenWidth - 20)/colum
@interface PostMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CirclePostMessageCollectionViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@property (nonatomic,strong) NSMutableArray<PostImageModel*> *images;
@property (nonatomic,copy) NSString *filePath;

@property (nonatomic,strong) AVAudioPlayer *player;

@end

@implementation PostMainViewController

- (IBAction)operationAction:(UIButton *)sender {
    RecordSoundView *recordSoundView = [[RecordSoundView alloc] initWithFrame:self.view.bounds RecordBlock:^(NSString *filePath) {
        self.filePath = filePath;
        
       
    }];
    [self.view addSubview:recordSoundView];
    
}




-(void)playing {
    [_player prepareToPlay];
    [_player play];
    [_showButton setTitle:@"播放中" forState:UIControlStateNormal];
}

-(void)stop{
    [_player stop];
    [_showButton setTitle:@"播放" forState:UIControlStateNormal];
}

- (IBAction)showAction:(UIButton *)sender {
  
    if (self.filePath) {
        if ([self.player isPlaying]) {
           
            [self stop];
        }else{
            
            NSError *playerError ;
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.filePath] error:&playerError];
            _player.delegate = self;
            _player.volume = 1;
         
            [self playing];
        }
        
    }
    
}
- (IBAction)postToServer:(UIButton *)sender {
    if (sender.tag == 0) {
        //提交服务器
        /*
         1.提交语音
         2.提交图片
         */
        if (self.filePath) {
            NSData *voiceData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.filePath]];
            [self postVoice:voiceData voiceName:self.filePath.lastPathComponent];
        }
        if (self.images.count > 0) {
            for (PostImageModel *model in self.images) {
                [self postImages:model.image imageName:model.imageName];
            }
        }
       
    }else{
        //暂存
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_model == nil) {
        _model = [[PostModel alloc] init];
        _model.contentStr = @"";
        _model.images = [NSMutableArray array];
        _model.recordUrl = @"";
    }
    _flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"CirclePostMessageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CirclePostMessageCollectionViewCell"];
    [self collectionViewLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1 + self.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostImageModel *imageModel = self.images[indexPath.item - 1];
    CirclePostMessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CirclePostMessageCollectionViewCell" forIndexPath:indexPath];
    cell.x_deleteButton.hidden = indexPath.item == 0 ? YES : NO;
    cell.x_contentImageView.image = indexPath.item == 0 ? [UIImage imageNamed:@"btn_background_photograph_image"] : imageModel.image;
    cell.delegate = self;
    cell.x_deleteButton.tag = indexPath.item - 1;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        //添加图片
        
        if (self.images.count >= 15) {
//            [[DDTipWords share] showWords:@"最多上传15张图片" withDelay:1.0 thenDoSth:^{
//                
//            }];
            return;
        }
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = NO;
                [self.navigationController presentViewController:picker animated:YES completion:NULL];
            }else{
                NSLog(@"照相机不可用");
            }
            
        }];
        
        UIAlertAction *photos = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSInteger less = 15 - self.images.count;
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(less) delegate:self];
            // 在这里设置imagePickerVc的外观
//            imagePickerVc.navigationBar.barTintColor = NavigationBarTintColor;
//            imagePickerVc.oKButtonTitleColorNormal = NavigationBarTintColor;
            [self.navigationController presentViewController:imagePickerVc animated:YES completion:nil];
        }];
        [alertC addAction:cancel];
        [alertC addAction:camera];
        [alertC addAction:photos];
        
        [self.navigationController presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma mark imagepick
//拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
  
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage * avatar = info[UIImagePickerControllerOriginalImage];
        //上传服务器
        NSString * dateStr = [self stringFromDate:[NSDate date]];
        
        PostImageModel *model = [[PostImageModel alloc] initWithImage:avatar imageName:dateStr];
        
        [self.images addObject:model];
    }];
    [self collectionViewLayout];
}

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    NSString * dateStr = [self stringFromDate:[NSDate date]];
    for (int j = 0; j< photos.count; j++) {
        NSString * str = [NSString stringWithFormat:@"%@-%ld",dateStr,(long)j];
        // 上传的图片名称
        PostImageModel *model = [[PostImageModel alloc] initWithImage:photos[j] imageName:str];
        [self.images addObject:model];
        
    }
    [self collectionViewLayout];
}





-(void)postVoice:(NSData*)voice voiceName:(NSString*)voiceName{
    [HttpTool post:@"/wenjianshangchuan.html" parameters:@{@"fenlei":@"2"} voice:voice voiceName:voiceName success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)postImages:(UIImage*)image imageName:(NSString*)imageName{
    [HttpTool post:@"/wenjianshangchuan.html" parameters:@{@"fenlei":@"1"} image:image imageName:imageName success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}


-(void)cancelImage:(NSInteger)item {
   
    [self.images removeObjectAtIndex:item];
 
    [self collectionViewLayout];
    [_collectionView reloadData];
}

-(void)collectionViewLayout {
    int row = (int)self.images.count/colum;
    _collectionViewHeightConstraint.constant = cellWidth * (row + 1);
    [self.collectionView reloadData];
}



-(NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}
@end
