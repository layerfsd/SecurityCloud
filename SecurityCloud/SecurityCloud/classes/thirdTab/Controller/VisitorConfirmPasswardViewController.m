//
//  VisitorConfirmPasswardViewController.m
//  SecurityCloud
//
//  Created by apple on 17/5/27.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "VisitorConfirmPasswardViewController.h"

@interface VisitorConfirmPasswardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *password0;
@property (weak, nonatomic) IBOutlet UITextField *password1;

@end

@implementation VisitorConfirmPasswardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmClicked:(UIButton *)sender {
    if (![self check]) {
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_tel forKey:@"tel"];
    [parameters setValue:_code forKey:@"yanzheng"];
    [HttpTool post:@"/qingbaoyuanxiugai.html" parameters:parameters success:^(id responseObject) {
        //注册完成 登录
        [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
        [UserManager setTelNum:_tel];
        [[UserManager sharedManager] goToLogin];
    } failure:^(NSError *error) {
        
    }];
}


-(BOOL)check {
    if ([NSString isEmpty:_password0.text]) {
        [SVProgressHUD showInfoWithStatus:@"输入密码"];
        return NO;
    }
    
    if (![NSString isValidPassword:_password0.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填写6到16位的密码"];
        return NO;
    }
    
    if ([NSString isEmpty:_password1.text]) {
        [SVProgressHUD showInfoWithStatus:@"输入确认密码"];
        return NO;
    }
    if (![_password1.text isEqualToString:_password0.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次密码不一致"];
        return NO;
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
