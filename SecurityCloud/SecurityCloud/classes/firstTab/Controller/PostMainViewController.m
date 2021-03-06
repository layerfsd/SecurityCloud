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
#import "Info+CoreDataClass.h"
#import "ImageModel+CoreDataClass.h"
#import "UITextView+Placeholder.h"
#import "CoreDataHelper.h"
#import "KZVideoViewController.h"
#import "KZVideoPlayer.h"
#import "KZVideoConfig.h"
#import "MoviePlayerView.h"
#define colum 4
#define cellWidth (kScreenWidth - 20)/colum
@interface PostMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CirclePostMessageCollectionViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,AVAudioPlayerDelegate,ESPictureBrowserDelegate,KZVideoViewControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UIView *topVIew;
@property (weak, nonatomic) IBOutlet UIView *recordView;

@property (nonatomic,strong) NSMutableArray<PostImageModel*> *images;
@property (nonatomic,strong) NSMutableArray<NSMutableDictionary*> *postImageDicts;
@property (nonatomic,strong) NSMutableDictionary *postVoiceDict;
@property (nonatomic,strong) NSMutableDictionary *postVideoDict;

@property (nonatomic,copy) NSString *filePath;

@property (nonatomic,strong) AVAudioPlayer *player;

@property (nonatomic,strong) KZVideoModel *videoModel;
@property (weak, nonatomic) IBOutlet UIView *videoPlayView;
@property (weak, nonatomic) IBOutlet UIButton *deleteVideoBtn;

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;

@end

@implementation PostMainViewController
- (IBAction)playVideo:(UIButton *)sender {
    NSString *path = [KZVideoUtil getVideoPath];
    path = [path stringByAppendingPathComponent:self.videoModel.videoAbsolutePath.lastPathComponent];

    NSURL * url = [NSURL fileURLWithPath:path];
    MoviePlayerView * mPlayer = [[MoviePlayerView alloc]initWithUrl:url];
    [mPlayer play];
}


- (IBAction)addVideo:(UIButton *)sender {
    if (sender.tag == 1) {
        //删除video
        self.videoModel = nil;
        _videoPlayView.hidden = YES;
       
        sender.hidden = YES;
    }else{
        KZVideoViewController *videoVC = [[KZVideoViewController alloc] init];
        videoVC.delegate = self;
        [videoVC startAnimationWithType:KZVideoViewShowTypeSmall];
    }
    
}

- (void)videoViewController:(KZVideoViewController *)videoController didRecordVideo:(KZVideoModel *)videoModel{
    //获取到视频
    self.videoModel = videoModel;
  
    
    NSString *path = [KZVideoUtil getVideoPath];
    _videoImageView.image = [UIImage imageNamed:[path stringByAppendingPathComponent:videoModel.thumAbsolutePath.lastPathComponent]];
    _videoPlayView.hidden = NO;
    
    _deleteVideoBtn.hidden = NO;
    
 
}


-(void)deleteFile:(NSString*)fileUrl {
    NSFileManager* fileManager=[NSFileManager defaultManager];
  
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:fileUrl];
    if (!blHave) {
       
        return ;
    }else {
      
        BOOL blDele= [fileManager removeItemAtPath:fileUrl error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}

- (IBAction)operationAction:(UIButton *)sender {
    //开启录音组件
    [self.view endEditing:YES];
    if (sender.selected) {
        //删除
//        [self deleteFile:self.filePath];
        self.filePath = nil;
        self.showButton.enabled = NO;
        self.recordButton.selected = NO;
    }else{
        //添加
        RecordSoundView *recordSoundView = [[RecordSoundView alloc] initWithFrame:self.view.bounds RecordBlock:^(NSString *filePath) {
            self.filePath = filePath;
            _showButton.enabled = YES;
            _recordButton.selected = YES;
        }];
        [self.view addSubview:recordSoundView];
    }
   
   
}




-(void)playing {
    [_player prepareToPlay];
    [_player play];
    _showButton.selected = YES;
}

-(void)stop{
    [_player stop];
    _showButton.selected = NO;
}

- (IBAction)showAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.filePath) {
        if ([self.player isPlaying]) {
           
            [self stop];
        }else{
            NSString *voicePath = VoicePath;
            voicePath = [voicePath stringByAppendingPathComponent:self.filePath.lastPathComponent];
            BOOL fileexit = [[NSFileManager defaultManager] fileExistsAtPath:voicePath];
            if (!fileexit) {
                [SVProgressHUD showErrorWithStatus:@"文件丢失"];
                return;
            }
            AVAudioSession *session =[AVAudioSession sharedInstance];
            NSError *sessionError;
            [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];

            NSError *playerError ;
            
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:voicePath] error:&playerError];
            _player.delegate = self;
            _player.volume = 1;
         
            [self playing];
        }
        
    }
    
}

-(void)postToServerWithData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:UserID forKey:@"user_id"];
    [parameters setValue:_textView.text forKey:@"content"];
//    [parameters setValue:[self.postImageIDs componentsJoinedByString:@","] forKey:@"img"];
//    [parameters setValue:self.postVoiceID forKey:@"luyin"];
    [parameters setValue:[UserManager sharedManager].address forKey:@"address"];
//    [parameters setValue:[UserManager sharedManager].location forKey:@"zuobiao"];
    [parameters setValue:[UserManager sharedManager].longitude forKey:@"longitude"];
    [parameters setValue:[UserManager sharedManager].latitude forKey:@"latitude"];
    
    [parameters setValue:[JsonHelper jsonWithObj:self.postImageDicts]  forKey:@"image"];
    [parameters setValue:[JsonHelper jsonWithObj:self.postVoiceDict] forKey:@"audio"];
    [parameters setValue:[JsonHelper jsonWithObj:self.postVideoDict] forKey:@"video"];
    
    [HttpTool post:SubmitMsg parameters:parameters success:^(id responseObject) {
        //添加成功 退出页面 清楚本地数据
        [self cancelInfo];
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}



-(void)cancelInfo {
    if (_info) {
        for (PostImageModel *model in self.images) {
            ImageModel *imageModel = [ImageModel MR_findByAttribute:@"imageName" withValue:model.imageName].firstObject;
            [imageModel MR_deleteEntity];
        }
        
        
        Info *thisInfo = [CoreDataHelper findInfoByTime:_info.creatTime];
        [thisInfo MR_deleteEntity];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [[NSNotificationCenter defaultCenter] postNotificationName:DraftBoxListViewControllerNotificationString object:nil];
    }
}

-(BOOL)check {
    if (!self.filePath && self.images.count == 0 && [NSString isEmpty:_textView.text] && self.videoModel == nil) {
        return NO;
    }
    return YES;
}

- (IBAction)postToServer:(UIButton *)sender {
    
    if (![self check]) {
        //请添加内容再上传
        [SVProgressHUD showErrorWithStatus:@"请添加内容"];
        return;
    }
    if (sender.tag == 0) {
      
        //提交服务器
        /*
         1.提交语音
         2.提交图片
         */
        //有语音需要上传
        
        
        //线程并行
        dispatch_group_t group = dispatch_group_create();
        
        if (self.filePath) {
            NSString *voicePath = VoicePath;
            voicePath = [voicePath stringByAppendingPathComponent:self.filePath.lastPathComponent];
            NSData *voiceData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:voicePath]];
            dispatch_group_enter(group);
            [HttpTool post:Upload parameters:nil voice:voiceData voiceName:self.filePath.lastPathComponent success:^(id responseObject) {
//                if ([responseObject[@"status"] isEqualToString:@"ok"]) {
                [self.postVoiceDict removeAllObjects];
                [self.postVoiceDict setValue:responseObject[@"data"][@"url"] forKey:@"name"];
                [self.postVoiceDict setValue:responseObject[@"data"][@"size"] forKey:@"size"];
//                    self.postVoiceID = responseObject[@"data"][@"id"];
//                }
                dispatch_group_leave(group);
            } failure:^(NSError *error) {
                dispatch_group_leave(group);
            }];
        }
        //有图片需要上传
        if (self.images.count > 0) {
            [self.postImageDicts removeAllObjects];
            for (PostImageModel *model in self.images) {
                dispatch_group_enter(group);
                [HttpTool post:Upload parameters:nil image:model.image imageName:model.imageName success:^(id responseObject) {
                    [self.postImageDicts removeAllObjects];
//                    if ([responseObject[@"status"] isEqualToString:@"ok"]) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setValue:responseObject[@"data"][@"url"] forKey:@"name"];
                        [dict setValue:responseObject[@"data"][@"size"] forKey:@"size"];
                        [self.postImageDicts addObject:dict];
//                    }
                    dispatch_group_leave(group);
                } failure:^(NSError *error) {
                    dispatch_group_leave(group);
                }];
            }
        }
        if (self.videoModel) {
            dispatch_group_enter(group);
            [HttpTool getToken:@"http://cntp31.lysoo.com/guanli/index.php/Api/Common/token" parameters:nil success:^(id responseObject) {
                NSString *token = responseObject[@"data"][@"token"];
               
                NSString *path = [KZVideoUtil getVideoPath];
                NSString *filePather = [path stringByAppendingPathComponent:self.videoModel.videoAbsolutePath.lastPathComponent];
                
               
                
                QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
                    NSLog(@"percent == %.2f", percent);
                }
                                                                             params:nil
                                                                           checkCrc:NO
                                                                 cancellationSignal:nil];
                QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                    builder.zone = [QNZone zone1];
                }];
                
                QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
                
                [upManager putFile:filePather key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    NSLog(@"info ===== %@", info);
                    NSLog(@"resp ===== %@", resp);
                    [self.postVideoDict removeAllObjects];
                    [self.postVideoDict setValue:resp[@"name"] forKey:@"name"];
                    [self.postVideoDict setValue:resp[@"size"] forKey:@"size"];
                    dispatch_group_leave(group);
                }
                            option:uploadOption];
            } failure:^(NSError *error) {
                dispatch_group_leave(group);
            }];
           
            
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
            //初始化页面或更新页面
            [self postToServerWithData];
        });
       
    }else{
        //暂存
         NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_defaultContext];
        if (_info) {
            //修改数据 并保存
            for (PostImageModel *model in self.images) {
                NSData *imageData = UIImagePNGRepresentation(model.image);
                ImageModel *imageModel = [ImageModel MR_createEntityInContext:localContext];
                imageModel.imageData = imageData;
                imageModel.imageName = model.imageName;
            }
            
            Info *thisInfo = [CoreDataHelper findInfoByTime:_info.creatTime];
            thisInfo.content = _textView.text;
            thisInfo.images = [self imagesPath];
            thisInfo.voicePath = self.filePath;
            thisInfo.videoPath = self.videoModel.videoAbsolutePath;
            thisInfo.videoImagePath = self.videoModel.thumAbsolutePath;
            thisInfo.userID = UserID;
            thisInfo.creatTime = [NSDate date];
            [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:DraftBoxListViewControllerNotificationString object:nil];
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            //添加新数据
            //保存所有的图片
            for (PostImageModel *model in self.images) {
                NSData *imageData = UIImagePNGRepresentation(model.image);
                ImageModel *imageModel = [ImageModel MR_createEntityInContext:localContext];
                imageModel.imageData = imageData;
                imageModel.imageName = model.imageName;
                [localContext MR_saveToPersistentStoreAndWait];
            }
            
            //保存信息
            Info *info = [Info MR_createEntityInContext:localContext];
            info.content = _textView.text;
            info.images = [self imagesPath];
            info.voicePath = self.filePath;
            info.videoPath = self.videoModel.videoAbsolutePath;
            info.videoImagePath = self.videoModel.thumAbsolutePath;
            info.userID = UserID;
            info.creatTime = [NSDate date];
            
            
            // 保存修改到当前上下文中.
            [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
               
                [[NSNotificationCenter defaultCenter] postNotificationName:DraftBoxListViewControllerNotificationString object:nil];
                 [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
       
        
       
        
    }
}

//图片数组字段
-(NSString*)imagesPath{
    NSMutableArray *paths = [NSMutableArray array];
    for (PostImageModel *model in self.images) {
        NSString *imagePath = model.imageName;
        [paths addObject:imagePath];
    }
    
    return [paths componentsJoinedByString:@","];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self stop];
    }
}

-(void)initData {
    if (![NSString isEmpty:_info.images]) {
        NSArray<NSString*> *imageNames = [_info.images componentsSeparatedByString:@","];
        for (NSString *imageName in imageNames) {
            ImageModel *imageModel = [ImageModel MR_findByAttribute:@"imageName" withValue:imageName].firstObject;
            UIImage *image = [UIImage imageWithData:imageModel.imageData];
            PostImageModel *model = [[PostImageModel alloc] initWithImage:image imageName:imageName];
            [self.images addObject:model];
            [self collectionViewLayout];
        }

    }
    if (_info.voicePath) {
        //初始化语音
        self.filePath = _info.voicePath;
        _showButton.enabled = YES;
        _recordButton.selected = YES;
    }else{
        _showButton.enabled = NO;
        _recordButton.selected = NO;
    }
    
    if (![NSString isEmpty:_info.content]) {
        _textView.text = _info.content;
    }
    if (_info.videoPath) {
        KZVideoModel *model = [KZVideoModel new];
        model.videoAbsolutePath = _info.videoPath;
        model.thumAbsolutePath = _info.videoImagePath;
        self.videoModel = model;
        _deleteVideoBtn.hidden = NO;
        _videoPlayView.hidden = NO;
        
        NSString *path = [KZVideoUtil getVideoPath];
        _videoImageView.image = [UIImage imageNamed:[path stringByAppendingPathComponent:model.thumAbsolutePath.lastPathComponent]];
        
//        KZVideoPlayer *player = [[KZVideoPlayer alloc] initWithFrame:_videoPlayView.bounds videoUrl:[NSURL fileURLWithPath:[path stringByAppendingPathComponent:model.videoAbsolutePath.lastPathComponent] isDirectory:NO]];
//        [_videoPlayView addSubview:player];
//        [player stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"上报";
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    _topVIew.layer.cornerRadius = 5;
    _topVIew.layer.masksToBounds = YES;
//    _topVIew.layer.borderWidth = 0.6;
//    _topVIew.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _recordView.layer.cornerRadius = 5;
    _recordView.layer.masksToBounds = YES;
//    _recordView.layer.borderWidth = 0.6;
//    _recordView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"CirclePostMessageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CirclePostMessageCollectionViewCell"];
    [self collectionViewLayout];
    _deleteVideoBtn.hidden = YES;
    _videoPlayView.hidden = YES;
    if (_info != nil) {
        //初始化数据
        [self initData];
    }else{
        _showButton.enabled = NO;
    }
    _textView.placeholder = @"请输入举报内容";
    
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
    
    CirclePostMessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CirclePostMessageCollectionViewCell" forIndexPath:indexPath];
    cell.x_deleteButton.hidden = indexPath.item == 0 ? YES : NO;
    cell.x_contentImageView.image = indexPath.item == 0 ? [UIImage imageNamed:@"btn_background_photograph_image"] : self.images[indexPath.item - 1].image;
    cell.delegate = self;
    cell.x_deleteButton.tag = indexPath.item - 1;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
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
    }else{
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        ESPictureBrowser *browser = [[ESPictureBrowser alloc] init];
        browser.delegate = self;
        [browser showFromView:cell picturesCount:[self.images count] currentPictureIndex:indexPath.item - 1];
    }
}
- (UIView *)pictureView:(ESPictureBrowser *)pictureBrowser viewForIndex:(NSInteger)index{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index + 1 inSection:0]];
    return cell;
}
/**
 获取对应索引的图片大小
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片大小
 */
- (CGSize)pictureView:(ESPictureBrowser *)pictureBrowser imageSizeForIndex:(NSInteger)index {
    return CGSizeMake(cellWidth, cellWidth);
}

/**
 获取对应索引默认图片，可以是占位图片，可以是缩略图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片
 */
- (UIImage *)pictureView:(ESPictureBrowser *)pictureBrowser defaultImageForIndex:(NSInteger)index {
    PostImageModel *model = self.images[index];
    return model.image;
}

- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    return @"";

}


#pragma mark imagepick
//拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
  
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage * avatar = info[UIImagePickerControllerOriginalImage];
        //上传服务器
        NSString * dateStr = [self stringFromDate:[NSDate date]];
        dateStr = [dateStr stringByAppendingString:@".png"];
        PostImageModel *model = [[PostImageModel alloc] initWithImage:avatar imageName:dateStr];
        
        [self.images addObject:model];
        [self collectionViewLayout];
    }];
    
}

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    NSString * dateStr = [self stringFromDate:[NSDate date]];
    for (int j = 0; j< photos.count; j++) {
        NSString * str = [NSString stringWithFormat:@"%@-%ld",dateStr,(long)j];
        str = [str stringByAppendingString:@".png"];
        // 上传的图片名称
        PostImageModel *model = [[PostImageModel alloc] initWithImage:photos[j] imageName:str];
        [self.images addObject:model];
        
    }
    [self collectionViewLayout];
}





-(void)postVoice:(NSData*)voice voiceName:(NSString*)voiceName finished:(void (^)(NSString *responseID))block{
    [HttpTool post:@"/api/wenjianshangchuan.html" parameters:@{@"fenlei":@"2"} voice:voice voiceName:voiceName success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"ok"]) {
            block(responseObject[@"data"][@"id"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)postImages:(UIImage*)image imageName:(NSString*)imageName finished:(void (^)(NSString *responseID))block{
    [HttpTool post:@"/api/wenjianshangchuan.html" parameters:@{@"fenlei":@"1"} image:image imageName:imageName success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"ok"]) {
            block(responseObject[@"data"][@"id"]);
        }
       
    } failure:^(NSError *error) {
        
    }];
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
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

-(NSMutableDictionary *)postVideoDict{
    if (_postVideoDict == nil) {
        _postVideoDict = [NSMutableDictionary dictionary];
    }
    return _postVideoDict;
}
-(NSMutableDictionary *)postVoiceDict{
    if (_postVoiceDict == nil) {
        _postVoiceDict = [NSMutableDictionary dictionary];
    }
    return _postVoiceDict;
}
-(NSMutableArray<NSMutableDictionary *> *)postImageDicts{
    if (_postImageDicts == nil) {
        _postImageDicts = [NSMutableArray array];
    }
    return _postImageDicts;
}


-(NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}
@end
