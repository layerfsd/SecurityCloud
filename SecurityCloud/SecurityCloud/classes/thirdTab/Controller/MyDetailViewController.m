//
//  MyDetailViewController.m
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MyDetailViewController.h"
#import "MyQRCodeViewController.h"
@interface MyDetailViewController ()


@end

@implementation MyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //头像
        return;
    }
    
    if (indexPath.row == 0){
        //昵称
    }else if (indexPath.row == 1){
        //我的二维码
       UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyQRCodeViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MyQRCodeViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        //手机绑定
    }


}

@end
