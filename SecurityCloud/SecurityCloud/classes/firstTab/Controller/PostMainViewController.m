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
#import "Info.h"
#import "UITextView+Placeholder.h"
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
@property (nonatomic,copy) NSMutableArray<NSString*> *postImageIDs;
@property (nonatomic,copy) NSString *postVoiceID;
@property (nonatomic,copy) NSString *filePath;

@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,assign) BOOL posted;

@end

@implementation PostMainViewController

- (IBAction)operationAction:(UIButton *)sender {
    //开启录音组件
//    RecordSoundView *recordSoundView = [[RecordSoundView alloc] initWithFrame:self.view.bounds RecordBlock:^(NSString *filePath) {
//        self.filePath = filePath;
//        
//       
//    }];
//    [self.view addSubview:recordSoundView];
    NSArray *infos = [Info MR_findAll];
    Info *inf = infos.firstObject;
    NSLog(@"%@",inf.images);
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

-(void)postToServerWithData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[UserManager sharedManager].userID forKey:@"qingbaoyuanid"];
    [parameters setValue:_textView.text forKey:@"neirong"];
    [parameters setValue:[self.postImageIDs componentsJoinedByString:@","] forKey:@"img"];
    [parameters setValue:self.postVoiceID forKey:@"luyin"];
    
    [HttpTool post:@"/qingbaotianjia.html" parameters:parameters success:^(id responseObject) {
        //添加成功 退出页面
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)postToServer:(UIButton *)sender {
    _posted = NO;
    if (sender.tag == 0) {
        if (!self.filePath && self.images.count == 0) {
            //请添加内容再上传
            return;
        }
        //提交服务器
        /*
         1.提交语音
         2.提交图片
         */
        //有语音需要上传
        if (self.filePath) {
            NSData *voiceData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.filePath]];
            [self postVoice:voiceData voiceName:self.filePath.lastPathComponent finished:^(NSString *responseID) {
                self.postVoiceID = responseID;
                if (self.postImageIDs.count == self.images.count && !_posted) {
                    _posted = YES;
                    //直接传到服务器
                    [self postToServerWithData];
                }
            }];
        }
        //有图片需要上传
        if (self.images.count > 0) {
            [self.postImageIDs removeAllObjects];
            for (PostImageModel *model in self.images) {
                [self postImages:model.image imageName:model.imageName finished:^(NSString *responseID) {
                    [self.postImageIDs addObject:responseID];
                    if (self.postImageIDs.count == self.images.count && !_posted) {
                        if (self.filePath && self.postVoiceID) {
                            _posted = YES;
                            //直接传到服务器
                            [self postToServerWithData];
                        }else if(!self.filePath){
                            _posted = YES;
                            //直接传到服务器
                            [self postToServerWithData];
                        }
                        
                    }
                }];
            }
        }
       
    }else{
        //暂存
        
        Info *info = [Info MR_createEntity];
        info.content = _textView.text;
        info.images = [self imagesPath];
        info.voicePath = self.filePath;
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
            //
        }];
    }
}

-(NSString*)imagesPath{
    NSMutableArray *paths = [NSMutableArray array];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    for (PostImageModel *model in self.images) {
        NSString *imagePath = [path stringByAppendingPathComponent:model.imageName];
        NSData *imageData = UIImagePNGRepresentation(model.image);
        [imageData writeToFile:imagePath atomically:YES];
        [paths addObject:imagePath];
    }
    
    return [paths componentsJoinedByString:@","];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_model == nil) {
        
    }
    _containerViewHeightConstraint.constant = self.view.bounds.size.height;
    _textView.placeholder = @"请输入举报内容";
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
    
    CirclePostMessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CirclePostMessageCollectionViewCell" forIndexPath:indexPath];
    cell.x_deleteButton.hidden = indexPath.item == 0 ? YES : NO;
    cell.x_contentImageView.image = indexPath.item == 0 ? [UIImage imageNamed:@"btn_background_photograph_image"] : self.images[indexPath.item - 1].image;
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
        dateStr = [dateStr stringByAppendingString:@".png"];
        PostImageModel *model = [[PostImageModel alloc] initWithImage:avatar imageName:dateStr];
        
        [self.images addObject:model];
    }];
    [self collectionViewLayout];
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
    [HttpTool post:@"/wenjianshangchuan.html" parameters:@{@"fenlei":@"2"} voice:voice voiceName:voiceName success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"ok"]) {
            block(responseObject[@"data"][@"id"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)postImages:(UIImage*)image imageName:(NSString*)imageName finished:(void (^)(NSString *responseID))block{
    [HttpTool post:@"/wenjianshangchuan.html" parameters:@{@"fenlei":@"1"} image:image imageName:imageName success:^(id responseObject) {
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

-(NSMutableArray *)postImageIDs {
    if (_postImageIDs == nil) {
        _postImageIDs = [NSMutableArray array];
    }
    return _postImageIDs;
}

-(NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}
@end
