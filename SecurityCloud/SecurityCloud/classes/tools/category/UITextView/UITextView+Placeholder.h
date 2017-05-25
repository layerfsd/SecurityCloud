//
//  UITextView+Placeholder.h
//  TodaySoft
//
//  Created by hsgene_xu on 2017/3/9.
//  Copyright © 2017年 haoyee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Placeholder)
@property (nonatomic,strong) NSString *placeholder;//占位符
@property (copy, nonatomic) NSNumber *limitLength;//限制字数
@end
