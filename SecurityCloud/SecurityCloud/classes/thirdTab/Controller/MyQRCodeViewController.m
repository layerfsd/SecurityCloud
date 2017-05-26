//
//  MyQRCodeViewController.m
//  SecurityCloud
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MyQRCodeViewController.h"
#import "UserModel.h"
@interface MyQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qRCodeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qRLitterImageView;

@end

@implementation MyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
