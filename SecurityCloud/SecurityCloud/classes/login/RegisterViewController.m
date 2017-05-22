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


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _noticeLabel.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SetPasswordViewController *vc = (SetPasswordViewController*)[segue destinationViewController];
    vc.tel = _phoneTextField.text;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}


@end
