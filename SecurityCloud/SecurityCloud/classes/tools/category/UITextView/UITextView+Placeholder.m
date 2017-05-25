//
//  UITextView+Placeholder.m
//  TodaySoft
//
//  Created by hsgene_xu on 2017/3/9.
//  Copyright © 2017年 haoyee. All rights reserved.
//

#import "UITextView+Placeholder.h"

@interface UITextView()
@property (nonatomic,strong) UILabel *placeholderLabel;//占位符
@property (nonatomic,strong) UILabel *wordCountLabel;//计算字数

@end

@implementation UITextView (Placeholder)
static NSString *PLACEHOLDLABEL = @"placelabel";
static NSString *PLACEHOLD = @"placehold";
static NSString *WORDCOUNTLABEL = @"wordcount";
static const void *limitLengthKey = &limitLengthKey;


#pragma mark -- set/get...

-(void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    
    objc_setAssociatedObject(self, &PLACEHOLDLABEL, placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)placeholderLabel {
    
    return objc_getAssociatedObject(self, &PLACEHOLDLABEL);
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    
    
    objc_setAssociatedObject(self, &PLACEHOLD, placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setPlaceHolderLabel:placeholder];
}

- (NSString *)placeholder {
    
    return objc_getAssociatedObject(self, &PLACEHOLD);
}


- (UILabel *)wordCountLabel {
    
    return objc_getAssociatedObject(self, &WORDCOUNTLABEL);
    
}
- (void)setWordCountLabel:(UILabel *)wordCountLabel {
    
    objc_setAssociatedObject(self, &WORDCOUNTLABEL, wordCountLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


- (NSNumber *)limitLength {
    
    return objc_getAssociatedObject(self, limitLengthKey);
}

- (void)setLimitLength:(NSNumber *)limitLength {
    objc_setAssociatedObject(self, limitLengthKey, limitLength, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addLimitLengthObserver:[limitLength intValue]];
    
    [self setWordcountLable:limitLength];
    
}

#pragma mark -- 配置占位符标签

- (void)setPlaceHolderLabel:(NSString *)placeholder {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextViewTextDidChangeNotification object:self];
    /*
     *  占位字符
     */
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.font = [UIFont systemFontOfSize:14.];
    self.placeholderLabel.text = placeholder;
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.placeholderLabel.textColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:211.0/255 alpha:1];
    CGRect rect = [placeholder boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame)-7, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.]} context:nil];
    self.placeholderLabel.frame = CGRectMake(4, 7, rect.size.width, rect.size.height);
    [self addSubview:self.placeholderLabel];
    self.placeholderLabel.hidden = self.text.length > 0 ? YES : NO;
    
}

#pragma mark -- 配置字数限制标签

- (void)setWordcountLable:(NSNumber *)limitLength {
    
    /*
     *  字数限制
     */
    
    self.wordCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.wordCountLabel.textAlignment = NSTextAlignmentLeft;
    self.wordCountLabel.hidden = YES;
    self.wordCountLabel.textColor = [UIColor redColor];
    self.wordCountLabel.font = [UIFont systemFontOfSize:8.];
    self.wordCountLabel.text = [NSString stringWithFormat:@"字数最多%@",self.limitLength];
    if (self.superview) {
        [self.superview addSubview:self.wordCountLabel];
        [self.wordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(@10);
        }];
    }
    
//    self.wordCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 100, CGRectGetHeight(self.frame) - 20, 100, 20)];
//    self.wordCountLabel.textAlignment = NSTextAlignmentRight;
//    self.wordCountLabel.textColor = [UIColor lightGrayColor];
//    self.wordCountLabel.font = [UIFont systemFontOfSize:13.];
//    if (self.text.length > [limitLength integerValue]) {
//        self.text = [self.text substringToIndex:[self.limitLength intValue]];
//    }
//    self.wordCountLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.text.length,limitLength];
//    [self addSubview:self.wordCountLabel];
    
}


#pragma mark -- 增加限制位数的通知
- (void)addLimitLengthObserver:(int)length {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitLengthEvent) name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark -- 限制输入的位数
- (void)limitLengthEvent {
    
    if ([self.text length] > [self.limitLength intValue]) {
        
//        self.text = [self.text substringToIndex:[self.limitLength intValue]];
    }
}


#pragma mark -- NSNotification

- (void)textFieldChanged:(NSNotification *)notification {
    if (self.placeholder) {
        self.placeholderLabel.hidden = YES;
        
        if (self.text.length == 0) {
            
            self.placeholderLabel.hidden = NO;
        }
    }
    if (self.limitLength) {
        NSLog(@"%@",self.limitLength);
        NSLog(@"%lu",self.text.length);
        NSString *temp = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (temp != nil) {
            self.wordCountLabel.hidden = self.text.length <= [self.limitLength integerValue];
        }
        
//        NSInteger wordCount = self.text.length;
//        if (wordCount > [self.limitLength integerValue]) {
//            wordCount = [self.limitLength integerValue];
//        }
//        self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/%@",wordCount,self.limitLength];
    }
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self];
}

@end
