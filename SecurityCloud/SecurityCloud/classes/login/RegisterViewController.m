//
//  RegisterViewController.m
//  SecurityShield
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "RegisterViewController.h"
#import "SetPasswordViewController.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger second;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _noticeLabel.hidden = YES;
    // Do any additional setup after loading the view.
}

-(BOOL)checkTel {
    if ([NSString isEmpty:_phoneTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填写电话号"];
        return NO;
    }
    if (![NSString isValidPhoneNumber:_phoneTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填写正确的电话号码"];
        return NO;
    }
    return YES;
    
}
- (IBAction)next:(UIButton *)sender {
    if(![self check]){return;}
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_phoneTextField.text forKey:@"tel"];
    [parameters setValue:_verificationCodeTextField.text forKey:@"yanzheng"];
    [HttpTool post:@"/qingbaoyuanxiugai.html" parameters:parameters success:^(id responseObject) {
        //注册完成 登录
        [self performSegueWithIdentifier:@"ToComfirmPassword" sender:self];
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)getCode:(UIButton *)sender {
    if (![self checkTel]) {
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_phoneTextField.text forKey:@"tel"];
    [HttpTool post:@"/shoujiyanzheng.html" parameters:parameters success:^(id responseObject) {
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
    if ([NSString isEmpty:_phoneTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填写电话号"];
        return NO;
    }
    if (![NSString isValidPhoneNumber:_phoneTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填写正确的电话号码"];
        return NO;
    }
    
    if ([NSString isEmpty:_verificationCodeTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填写验证码"];
        return NO;
    }
    
    return YES;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToComfirmPassword"]) {
        SetPasswordViewController *vc = (SetPasswordViewController*)[segue destinationViewController];
        vc.tel = _phoneTextField.text;
        vc.code = _verificationCodeTextField.text;
    }
    
}




@end
