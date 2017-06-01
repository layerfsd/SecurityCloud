//
//  RegisterFinishedViewController.m
//  SecurityShield
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "RegisterFinishedViewController.h"

@interface RegisterFinishedViewController ()

@end

@implementation RegisterFinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)gotoLogin:(UIButton *)sender {
    //去登录
    NSDictionary *parameters = @{@"tel":[UserManager getTelNum],@"password":[UserManager sharedManager].password};
    [HttpTool post:@"/qingbaoyuandenglu.html" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"fail"]) {
        
        }else if ([responseObject[@"status"] isEqualToString:@"ok"]){
            //登录成功
            UserManager *um = [UserManager mj_objectWithKeyValues:responseObject[@"data"]];
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
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
