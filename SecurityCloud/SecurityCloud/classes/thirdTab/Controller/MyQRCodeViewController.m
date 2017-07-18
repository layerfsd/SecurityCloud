//
//  MyQRCodeViewController.m
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MyQRCodeViewController.h"
#import "UserModel.h"
#import "UIImage+QRCode.h"
#import "UserManager.h"
#import <UShareUI/UShareUI.h>
#import "SGQRCodeGenerateManager.h"
@interface MyQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qRCodeImageView;


@end

@implementation MyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码";
    [self initData];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
}

-(void)share {
    
}
-(void)initData {
   [_iconImageVIew sd_setImageWithURL:[NSURL URLWithString:_model.imgurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       UIImage *qrImage = [SGQRCodeGenerateManager SG_generateWithLogoQRCodeData:[NSString stringWithFormat:@"%@%@",advertiseUrl,_model.userID]  logoImageName:image logoScaleToSuperView:0.14];
       
       
      
       _qRCodeImageView.image = qrImage;
   }];
    _nameLabel.text = _model.name;
    if (_model.biaoqian == nil) {
        _tagsLabel.text = @"目前还没绑定标签";
    }else{
        NSString *labelStr = @"标签：";
        for (UserLabel *label in _model.biaoqian) {
            labelStr = [labelStr stringByAppendingString:label.biaoti];
            labelStr = [labelStr stringByAppendingString:@" "];
        }
        _tagsLabel.text = labelStr;
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
