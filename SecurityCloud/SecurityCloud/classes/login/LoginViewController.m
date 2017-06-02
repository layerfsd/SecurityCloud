//
//  LoginViewController.m
//  SecurityShield
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "Md5Util.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _noticeLabel.hidden = YES;
    if ([UserManager getTelNum]) {
        _userNameLabel.text = [UserManager getTelNum];
    }
}
- (IBAction)findPwd:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    RegisterViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    vc.isFound = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(BOOL)checkText {
    _noticeLabel.hidden = NO;
    if ([NSString isEmpty:_userNameLabel.text]) {
        _noticeLabel.text = @"请填写手机号码";
        return NO;
    }
    if (![NSString isValidPhoneNumber:_userNameLabel.text]) {
        _noticeLabel.text = @"请填写正确的手机号码";
        return NO;
    }
    if ([NSString isEmpty:_passwordLabel.text]) {
        _noticeLabel.text = @"请填写密码";
        return NO;
    }
    if (![NSString isValidPassword:_passwordLabel.text]) {
        _noticeLabel.text = @"请填写6到16位的密码";
        return NO;
    }
    _noticeLabel.hidden = YES;
    return YES;
}

- (IBAction)loginAction:(UIButton *)sender {
    if (![self checkText]) {
        return;
    }
    NSDictionary *parameters = @{@"tel":_userNameLabel.text,@"password":[Md5Util encryptMD5:_passwordLabel.text]};
    [HttpTool post:@"/qingbaoyuandenglu.html" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"fail"]) {
            _noticeLabel.hidden = NO;
            _noticeLabel.text = @"用户名或者密码错误";
        }else if ([responseObject[@"status"] isEqualToString:@"ok"]){
            //登录成功
            UserManager *um = [UserManager mj_objectWithKeyValues:responseObject[@"data"]];
            [um archiver];
            [UserManager setTelNum:_userNameLabel.text];
            [um goToMain];
        }else{
            
        }
        
        //登录成功
    } failure:^(NSError *error) {
        //登录失败
        NSLog(@"error");
    }];
}

- (IBAction)visitorLogin:(UIButton *)sender {
    //游客登录
    [HttpTool post:@"/qingbaoyuantianjia.html" parameters:nil success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"fail"]) {
            _noticeLabel.hidden = NO;
            _noticeLabel.text = responseObject[@"message"];
        }else if ([responseObject[@"status"] isEqualToString:@"ok"]){
            NSMutableDictionary *res = [NSMutableDictionary dictionary];
            [res setValue:responseObject[@"data"] forKey:@"id"];
            //登录成功
            UserManager *um = [UserManager mj_objectWithKeyValues:res];
            [um archiver];
            [um goToMain];
        }else{
            
        }
        
        //登录成功
    } failure:^(NSError *error) {
        //登录失败
        NSLog(@"error");
    }];

    
   
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark textFieldDelegate


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
