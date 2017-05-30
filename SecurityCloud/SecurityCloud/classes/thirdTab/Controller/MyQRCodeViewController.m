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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
}

-(void)share {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = @"http://mobile.umeng.com/social";
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
        }];
    }];
}
-(void)initData {
   [_iconImageVIew sd_setImageWithURL:[NSURL URLWithString:_model.imgurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       UIImage *qrImage =  [UIImage qrImageForString:[NSString stringWithFormat:@"%@?userID=%@",advertiseUrl,_model.userID] imageSize:70 logoImageSize:10 logo:image];
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
