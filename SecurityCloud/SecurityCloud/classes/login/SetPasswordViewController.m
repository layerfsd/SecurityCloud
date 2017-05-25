//
//  SetPasswordViewController.m
//  SecurityShield
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "SetPasswordViewController.h"

#import "Md5Util.h"
@interface SetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _noticeLabel.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)checkText {
    _noticeLabel.hidden = NO;
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (![self checkText]) {
        return NO;
    }else{
        NSDictionary *parameters = @{@"tel":_tel,@"password":[Md5Util encryptMD5:_passwordTextField.text]};
        [HttpTool post:@"/qingbaoyuantianjia.html" parameters:parameters success:^(id responseObject) {
            //注册失败的用户
            if ([responseObject[@"status"] isEqualToString:@"fail"]) {
                _noticeLabel.hidden = NO;
                _noticeLabel.text = @"注册失败";
            }else if ([responseObject[@"status"] isEqualToString:@"ok"]){
                ////注册成功的用户
                [UserManager setTelNum:_tel];
                [self performSegueWithIdentifier:@"gotoFinish" sender:self];
            }else{
                
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    return NO;
}


@end
