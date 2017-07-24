//
//  PersonImageViewController.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/27.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "PersonImageViewController.h"

@interface PersonImageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PersonImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(changeImage)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(changeImage)];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    // Do any additional setup after loading the view from its nib.
}
-(void)changeImage {
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
       
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(1) delegate:self];
        [self.navigationController presentViewController:imagePickerVc animated:YES completion:nil];
    }];
    [alertC addAction:cancel];
    [alertC addAction:camera];
    [alertC addAction:photos];
    
    [self.navigationController presentViewController:alertC animated:YES completion:nil];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

//拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage * avatar = info[UIImagePickerControllerOriginalImage];
        //上传服务器
        NSString * dateStr = [self stringFromDate:[NSDate date]];
        dateStr = [dateStr stringByAppendingString:@".png"];
        
        [self postImages:avatar imageName:dateStr];
       
    }];
   
}

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    NSString * dateStr = [self stringFromDate:[NSDate date]];
    dateStr = [dateStr stringByAppendingString:@".png"];
    
    [self postImages:photos.firstObject imageName:dateStr];
}
-(void)postImages:(UIImage*)image imageName:(NSString*)imageName {
    [HttpTool post:@"/api/wenjianshangchuan.html" parameters:@{@"fenlei":@"1"} image:image imageName:imageName success:^(id responseObject) {
        NSString *imageID = responseObject[@"data"][@"id"];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"url"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [self changeInfo:imageID];
    } failure:^(NSError *error) {
        
    }];
}

-(void)changeInfo:(NSString*)imgID {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:UserID forKey:@"id"];
    [parameters setValue:imgID forKey:@"img"];
   
    [HttpTool post:@"/api/qingbaoyuanxiugai.html" parameters:parameters success:^(id responseObject) {
        //注册完成 登录
        [[NSNotificationCenter defaultCenter] postNotificationName:FirstViewControllerReload object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:MyDetailViewControllerReload object:nil];
        [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
        
    } failure:^(NSError *error) {
        
    }];
}

@end
