//
//  HanderMsgView.m
//  SecurityCloud
//
//  Created by apple on 17/5/29.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "HanderMsgView.h"
#import "IQUIView+Hierarchy.h"
#import "UITextView+Placeholder.h"
@interface HanderMsgView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *handTypeTextField;
@property (weak, nonatomic) IBOutlet UISwitch *isPushSwitch;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;


@end
@implementation HanderMsgView
- (IBAction)actionClicked:(UIButton *)sender {
    if (sender.tag == 0) {
        [self removeFromSuperview];
        return;
    }
    
    if ([self check] && self.block) {
        self.block(_handTypeTextField.text,_isPushSwitch.on,_contentTextView.text);
        [self removeFromSuperview];
    }
}
- (IBAction)bgClicked:(UIButton *)sender {
    [self removeFromSuperview];
}

-(BOOL)check {
    return YES;
}

-(instancetype)handerMsgWithFrame:(CGRect)frame finishedBlock:(HanderMsgViewDoneBlock)block {
    HanderMsgView *vw = [[[NSBundle mainBundle] loadNibNamed:@"HanderMsgView" owner:nil options:nil] firstObject];
    vw.frame = frame;
    vw.block = block;
    return vw;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    _handTypeTextField.text = @"采用";
    _contentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _contentTextView.layer.borderWidth = 0.8;
    _contentTextView.placeholder = @"反馈信息";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.isAskingCanBecomeFirstResponder == NO){
        [self endEditing:YES];
        [self showAction];
    }
    
    return NO;
}

-(void)showAction{
    NSArray *colors = [NSArray arrayWithObjects:@"采用", @"不采用", nil];
    NSInteger selectedIndex = [colors indexOfObject:_handTypeTextField.text];
    
    [ActionSheetStringPicker showPickerWithTitle:@"选择一种处理方式"
                                            rows:colors
                                initialSelection:selectedIndex
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           _handTypeTextField.text = selectedValue;
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         
                                     }
                                          origin:_handTypeTextField];
}

@end
