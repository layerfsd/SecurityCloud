//
//  OutSiderButton.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/31.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "OutSiderButton.h"

@implementation OutSiderButton


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIColor *color = [UIColor colorWithRed:61.0/255 green:206.0/255 blue:243.0/255 alpha:1];

    NSInteger pulsingCount = 3;
    double animationDuration = 8;
    CALayer * animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        
//        pulsingLayer.frame = CGRectMake(rect.size.width/2*(1-1/sqrt(2)), rect.size.width/2*(1-1/sqrt(2)), rect.size.width/sqrt(2), rect.size.width/sqrt(2));
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.width);
        pulsingLayer.borderColor = color.CGColor;
        pulsingLayer.borderWidth = 2;
//        pulsingLayer.cornerRadius = rect.size.width/(2*sqrt(2));
        pulsingLayer.cornerRadius = rect.size.width/2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1;
        scaleAnimation.toValue = @1.5;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:animationLayer];
}


@end
