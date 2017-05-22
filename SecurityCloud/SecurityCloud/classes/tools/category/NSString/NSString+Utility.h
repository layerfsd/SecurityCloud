//
//  NSString+Utility.h
//  LXVolunteer
//
//  Created by 周培玉 on 15/5/20.
//  Copyright (c) 2015年 zhoupeiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Utility)

/**
 *  判断字符串存不存在，不存在返回nil,存在返回本身
 *
 *  @param str 字符串
 */
+ (NSString *)safeString:(NSString *)str;

/**
 *  字符串长度
 */
+ (NSInteger)lengthForString:(NSString*)string;
/**
 *  文件大小
 */
+ (NSString *)fileSizeStringFromBytes:(uint64_t)byteSize;

/**
 *  字符串中包不包含特殊字符
 */
+ (BOOL)specialCharInString:(NSString *)str;

/**
 *  stringForDate
 */
+ (NSString *)stringForDate:(NSDate *)date;

/**
 *  stringForTimeStamp
 */
+ (NSString *)stringForTimeStamp:(NSTimeInterval)ts;

/**
 *  todayStringForDate
 */
+ (NSString *)todayStringForDate:(NSDate *)aDate;

/**
 *  stringForNSDate
 */
+ (NSString *)stringForNSDate:(NSDate *)date;

/**
 *  dateForNSString
 */
+ (NSDate *)dateForNSString:(NSString *)aString;

/**
 *  dateForNSStringForGMT
 */
+ (NSDate *)dateForNSStringForGMT:(NSString *)aString;

+ (NSString *)getTime:(NSString *)shijianchuo;

+ (NSString *)getDayTime:(double)beTime;

/**
 *  分割字符串
 */
+ (NSArray *)separatedByString:(NSString *)orginString string:(NSString *)string;

/**
 *  截取子串
 */
+ (NSString *)getSunString:(NSString *)orginString Loc:(NSInteger)loc length:(NSInteger)length;

/*
 *  根据字号和内容尺寸返回字符串size
 *
 *  @param font 字符大小
 *  @param size constrain 大小
 *  @return 字符串size
 */
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 *  根据字体大小返回段落size
 *
 */
- (CGSize)getSizeWithFont:(UIFont *)font;

/**
 *  根据字号和行间距返回段落size
 */
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size AndLineHeight:(CGFloat)lineHeight;

/**
 *  根据字号、内容尺寸、段落样式返回行间距
 */
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size AndParagraphStyle:(NSParagraphStyle *)paragraphStyle;

/**
 *  电话号码检测
 */
- (BOOL)checkPhoneNum;

/**
 *  获取下划线AttibutedString
 */
- (NSAttributedString *)getAttributedStrWithUnderLine;

/**
 *  获取下划线AttibutedString 并改变颜色
 */
- (NSAttributedString *)getAttributedStrWithUnderLineAndColor:(UIColor *)color;

/**
 *  MD5
 */
- (NSString *)getMD5;

/**
 *  去除空格 和 换行
 */
- (NSString *)getRealStr;

/**
 *  数量转换
 */
- (NSString *)getShotCount;


/**
 *  判断手机号是否合法
 */

+ (BOOL)isValidPhoneNumber:(NSString *)number;

/**
 *  判断密码
 */
+ (BOOL)isValidPassword:(NSString *)password;

/**
 *  短信验证码
 */
+ (BOOL)isValidVerifyCode:(NSString *)verifyCode;

/**
 *  图片验证码
 */
+ (BOOL)isValidPictureCode:(NSString *)pictureCode;

- (NSMutableString *)replaceStrintWithPoint:(NSString *)str;

+(NSString *)getIdentifier;

/**
 *  检测是否为空字符串
 */
+ (BOOL)isEmpty:(NSString *)str;
/**
 *  获取label每行文字
 */
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label;

/**
   获取label高度
 */
+ (CGFloat)heightOfString:(NSString *)string width:(NSUInteger)width font:(UIFont *)font;
@end
