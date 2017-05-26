//
//  VerticalButton.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "VerticalButton.h"

@implementation VerticalButton

-(void)setImageAndTitle:(UIImage*)image title:(NSString*)title{
    [self setImage:image forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width * 0.5;
    center.y = self.imageView.frame.size.height * 0.5 + 8;
    self.imageView.center = center;
    
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = 0;
    titleFrame.origin.y = self.imageView.frame.size.height + 8;
    titleFrame.size.width = self.frame.size.width;
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    self.titleLabel.frame = titleFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
