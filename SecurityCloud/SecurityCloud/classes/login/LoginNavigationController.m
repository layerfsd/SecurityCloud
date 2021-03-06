//
//  LoginNavigationController.m
//  SecurityCloud
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "LoginNavigationController.h"

@interface LoginNavigationController ()

@end

@implementation LoginNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
////    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
////    self.navigationBar.shadowImage = [UIImage new];
//    self.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationBar.translucent = YES;
//    self.navigationBar.tintColor = [UIColor blackColor];
//  
//    //设置字体颜色
//    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationBar setBackgroundImage:[self createImageWithColor:navColor] forBarMetrics:UIBarMetricsDefault]; 
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.barTintColor = navColor;
//    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor];
    //设置字体颜色
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
}

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle{
    //返回当前控制器
    return self.topViewController;
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
