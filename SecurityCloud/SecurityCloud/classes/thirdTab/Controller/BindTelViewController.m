//
//  BindTelViewController.m
//  SecurityCloud
//
//  Created by apple on 17/5/27.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "BindTelViewController.h"
#import "VisitorConfirmPasswardViewController.h"
@interface BindTelViewController ()
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger second;
@end

@implementation BindTelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)next:(UIButton *)sender {
    if (![self check]) {
        return;
    }
    if ([UserManager sharedManager].tel != nil || [NSString isEmpty:[UserManager sharedManager].tel]) {
        //直接修改 无需设置密码
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:_telTextField.text forKey:@"tel"];
        [parameters setValue:_codeTextField.text forKey:@"yanzheng"];
        [HttpTool post:@"/qingbaoyuanxiugai.html" parameters:parameters success:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
        } failure:^(NSError *error) {
            
        }];
    }else{
        VisitorConfirmPasswardViewController *vc = [VisitorConfirmPasswardViewController new];
        vc.tel = _telTextField.text;
        vc.code = _codeTextField.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(BOOL)check {
    if ([NSString isEmpty:_telTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填写电话号"];
        return NO;
    }
    if (![NSString isValidPhoneNumber:_telTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填写正确的电话号码"];
        return NO;
    }
    
    if (![NSString isEmpty:_codeTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填写验证码"];
        return NO;
    }
    
    return YES;
}

-(BOOL)checkTel {
    if ([NSString isEmpty:_telTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填写电话号"];
        return NO;
    }
    if (![NSString isValidPhoneNumber:_telTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填写正确的电话号码"];
        return NO;
    }
    return YES;

}
- (IBAction)getCode:(UIButton *)sender {
    if (![self checkTel]) {
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_telTextField.text forKey:@"tel"];
    [HttpTool post:@"/shoujiyanzheng.html" parameters:parameters success:^(id responseObject) {
        [self codeGeted];
        [SVProgressHUD showSuccessWithStatus:@"验证码已发到您的手机上"];
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

-(void)codeGeted{
    _second = 60;
    _codeButton.enabled = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCounted) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
}

-(void)timeCounted{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_codeButton setTitle:[NSString stringWithFormat:@"剩余%ld秒",(long)_second] forState:UIControlStateNormal];
    });
    if (_second == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _codeButton.enabled = YES;
            [_codeButton setTitle:@"验证码" forState:UIControlStateNormal];
        });
        [_timer invalidate];
    }else{
        _second--;
    }
    
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
