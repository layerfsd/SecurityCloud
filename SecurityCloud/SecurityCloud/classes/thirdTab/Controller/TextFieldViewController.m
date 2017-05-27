//
//  TextFieldViewController.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/27.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "TextFieldViewController.h"

@interface TextFieldViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation TextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textField.text = _nameStr;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(sure)];
    // Do any additional setup after loading the view from its nib.
}
-(void)sure{
    if ([NSString isEmpty:_textField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:UserID forKey:@"id"];
    [parameters setValue:_textField.text forKey:@"name"];
    
    [HttpTool post:@"/qingbaoyuanxiugai.html" parameters:parameters success:^(id responseObject) {
        //注册完成 登录
        [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:FirstViewControllerReload object:nil];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
