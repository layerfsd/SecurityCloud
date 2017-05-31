//
//  MsgDetailViewController.m
//  SecurityCloud
//
//  Created by apple on 17/5/30.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MsgDetailViewController.h"

@interface MsgDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation MsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentTextView.text = _contentStr;
    // Do any additional setup after loading the view from its nib.
}

//-(void)setContentStr:(NSString *)contentStr {
//    _contentStr = contentStr;
//    _contentTextView.text = contentStr;
//}
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
