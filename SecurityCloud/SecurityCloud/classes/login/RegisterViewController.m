//
//  RegisterViewController.m
//  SecurityShield
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "RegisterViewController.h"

#import "Md5Util.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextField;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger second;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _noticeLabel.hidden = YES;
    
    UIImageView *telM = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    UIView *telMV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [telMV addSubview:telM];
    telM.image = [UIImage imageNamed:@"手机"];
    _phoneTextField.leftView = telMV;
    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
//
    UIImageView *codeM = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    codeM.image = [UIImage imageNamed:@"验证码验证"];
    UIView *codeMV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [codeMV addSubview:codeM];
    
    _verificationCodeTextField.leftView = codeMV;
    _verificationCodeTextField.leftViewMode = UITextFieldViewModeAlways;
//
    UIImageView *pwdM = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    pwdM.image = [UIImage imageNamed:@"密码"];
    UIView *pwdMV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [pwdMV addSubview:pwdM];
    _passwordTextField.leftView = pwdMV;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
//
    UIImageView *pwdSM = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    pwdSM.image = [UIImage imageNamed:@"确认密码"];
    UIView *pwdSMV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [pwdSMV addSubview:pwdSM];
    _surePasswordTextField.leftView = pwdSMV;
    _surePasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    // Do any additional setup after loading the view.
}

-(BOOL)checkTel {
    _noticeLabel.hidden = NO;
    if ([NSString isEmpty:_phoneTextField.text]) {
        _noticeLabel.text = @"请填写电话号";
        return NO;
    }
    if (![NSString isValidPhoneNumber:_phoneTextField.text]) {
        _noticeLabel.text = @"请填写正确的电话号码";
        return NO;
    }
    _noticeLabel.hidden = YES;
    return YES;
    
}
- (IBAction)next:(UIButton *)sender {
    if(![self check]){return;}
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_phoneTextField.text forKey:@"tel"];
    [parameters setValue:_verificationCodeTextField.text forKey:@"yanzheng"];
    [parameters setValue:[Md5Util encryptMD5:_passwordTextField.text] forKey:@"password"];
    
    if (_isFound) {
        [HttpTool post:@"/api/qingbaoyuanzhaohui.html" parameters:parameters success:^(id responseObject) {
            //注册完成 登录
            [UserManager sharedManager].password = [Md5Util encryptMD5:_passwordTextField.text];
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            [UserManager setTelNum:_phoneTextField.text];
            [self performSegueWithIdentifier:@"ToFinishRegister" sender:self];
        } failure:^(NSError *error) {
            
        }];
    }else{
        [HttpTool post:@"/api/qingbaoyuantianjia.html" parameters:parameters success:^(id responseObject) {
            //注册完成 登录
            [UserManager sharedManager].password = [Md5Util encryptMD5:_passwordTextField.text];
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            [UserManager setTelNum:_phoneTextField.text];
            [self performSegueWithIdentifier:@"ToFinishRegister" sender:self];
        } failure:^(NSError *error) {
            
        }];
    }
    
    
    
//
    
    
}

- (IBAction)getCode:(UIButton *)sender {
    if (![self checkTel]) {
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_phoneTextField.text forKey:@"tel"];
    [HttpTool post:@"/api/shoujiyanzheng.html" parameters:parameters success:^(id responseObject) {
        [self codeGeted];
        [SVProgressHUD showSuccessWithStatus:@"验证码已发到您的手机上"];
    } failure:^(NSError *error) {
        
    }];
}
-(void)codeGeted{
    _second = 60;
    _getVerificationCodeButton.enabled = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCounted) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
}

-(void)timeCounted{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_getVerificationCodeButton setTitle:[NSString stringWithFormat:@"剩余%ld秒",(long)_second] forState:UIControlStateNormal];
    });
    if (_second == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _getVerificationCodeButton.enabled = YES;
            [_getVerificationCodeButton setTitle:@"验证码" forState:UIControlStateNormal];
        });
        [_timer invalidate];
    }else{
        _second--;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)check {
    _noticeLabel.hidden = NO;
    if ([NSString isEmpty:_phoneTextField.text]) {
        _noticeLabel.text = @"请填写电话号";
        return NO;
    }
    if (![NSString isValidPhoneNumber:_phoneTextField.text]) {
        _noticeLabel.text = @"请填写正确的电话号码";
        return NO;
    }
    
    if ([NSString isEmpty:_verificationCodeTextField.text]) {
        _noticeLabel.text = @"请填写验证码";
        return NO;
    }
    
    if ([NSString isEmpty:_passwordTextField.text]) {
        _noticeLabel.text = @"请输入密码";
        return NO;
    }
    if (![NSString isValidPassword:_passwordTextField.text]) {
        _noticeLabel.text = @"请填写6到16位的密码";
        return NO;
    }
    if ([NSString isEmpty:_surePasswordTextField.text]) {
        _noticeLabel.text = @"请填写确认密码";
        return NO;
    }
    if (![NSString isValidPassword:_surePasswordTextField.text]) {
        _noticeLabel.text = @"请填写6到16位的确认密码";
        return NO;
    }
    if (![_passwordTextField.text isEqualToString:_surePasswordTextField.text]) {
        _noticeLabel.text = @"两次密码不一致请重新填写";
        return NO;
    }
    _noticeLabel.hidden = YES;
    
    return YES;
}



#pragma mark - Navigation






@end
