//
//  ChangePasswordViewController.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/31.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Md5Util.h"
@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;

@property (weak, nonatomic) IBOutlet UITextField *changedPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *sureChangedPwdTextField;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@end

@implementation ChangePasswordViewController
- (IBAction)btnClicked:(UIButton *)sender {
    if (![self check]) {
        return;
    }
    if (![[Md5Util encryptMD5:_oldPwdTextField.text] isEqualToString:[UserManager sharedManager].password]) {
        _noticeLabel.hidden = NO;
        _noticeLabel.text = @"原始密码有误";
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:UserID forKey:@"id"];
    [parameters setValue:[Md5Util encryptMD5:_changedPwdTextField.text] forKey:@"password"];
    [HttpTool post:@"/api/qingbaoyuanxiugai.html" parameters:parameters success:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
        if([UserManager deleteFile]){
            [[UserManager sharedManager] goToLogin];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(BOOL)check {
    _noticeLabel.hidden = NO;
    if ([NSString isEmpty:_oldPwdTextField.text]) {
        _noticeLabel.text = @"请输入密码";
        return NO;
    }
    if (![NSString isValidPassword:_oldPwdTextField.text]) {
        _noticeLabel.text = @"请填写6到16位的密码";
        return NO;
    }
    if ([NSString isEmpty:_changedPwdTextField.text]) {
        _noticeLabel.text = @"请填写确认密码";
        return NO;
    }
    if (![NSString isValidPassword:_changedPwdTextField.text]) {
        _noticeLabel.text = @"请填写6到16位的确认密码";
        return NO;
    }
    if (![_changedPwdTextField.text isEqualToString:_sureChangedPwdTextField.text]) {
        _noticeLabel.text = @"两次密码不一致请重新填写";
        return NO;
    }
    _noticeLabel.hidden = YES;
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
