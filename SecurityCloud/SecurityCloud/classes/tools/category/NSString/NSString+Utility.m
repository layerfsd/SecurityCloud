//
//  NSString+Utility.m
//  LXVolunteer
//
//  Created by 周培玉 on 15/5/20.
//  Copyright (c) 2015年 zhoupeiyu. All rights reserved.
//

#import "NSString+Utility.h"
#import <CoreText/CoreText.h>
#import <CommonCrypto/CommonDigest.h>

#define kCommonUtilsGigabyte (1024 * 1024 * 1024)
#define kCommonUtilsMegabyte (1024 * 1024)
#define kCommonUtilsKilobyte 1024

@implementation NSString (Utility)

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{

        NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
}

- (CGSize)getSizeWithFont:(UIFont *)font{
    
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        return [self sizeWithAttributes:attributes];

}

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size AndLineHeight:(CGFloat)lineHeight{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineHeight];
    return  [self getSizeWithFont:font constrainedToSize:size AndParagraphStyle:paragraphStyle];
}

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size AndParagraphStyle:(NSParagraphStyle *)paragraphStyle{
    NSDictionary * attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
}

+ (NSString *)safeString:(NSString *)str{
    if (!str) {
        return @"";
    }
    else {
        return str;
    }
}

/**
 *  判断输入的字符串是否全部为空格
 */
+ (BOOL)isEmpty:(NSString *)str
{
    if (!str) {
        return true;
    }
    else
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        }
        else
        {
            return false;
        }
    }
}

- (NSString *)successNoti{
    return [NSString stringWithFormat:@"%@SuccessNoti",self];
}

- (NSString *)failNoti{
    return [NSString stringWithFormat:@"%@FailNoti",self];
}

- (NSUInteger)realLength{
    return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
}

- (NSString *)getRealStr{
    return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)checkPhoneNum{
    if (self.length != 11) {
        return NO;
    }
    NSString *phoneRegex = @"^(1[0-9])\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (NSAttributedString *)getAttributedStrWithUnderLine{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    return str;
}

- (NSAttributedString *)getAttributedStrWithUnderLineAndColor:(UIColor *)color{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:color range:strRange];
    return str;
}

- (NSString *)getMD5{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString  stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4],
            result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12],
            result[13], result[14], result[15]
            ];
}

- (NSString*)getTimeFormat{
    if (self.realLength == 0) {
        return nil;
    }
    
    NSString *reFormat =@"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.integerValue];
    
    NSInteger now =[[NSDate date] timeIntervalSince1970];
    
    //来自未来
    if (self.integerValue>now) {
        reFormat = [formatter stringFromDate:confromTimesp];
    }
    if (self.integerValue==now) {
        reFormat = @"现在";
    }
    NSInteger sub =now-self.integerValue;
    if (sub>1&&sub<60) {
        reFormat = [NSString stringWithFormat:@"%ld秒前",(long)sub];
    }
    
    if (sub>60&&sub<60*60) {
        reFormat = [NSString stringWithFormat:@"%ld分钟前",(long)sub/60];
    }
    
    if (sub>60*60&&sub<60*60*24) {
        reFormat = [NSString stringWithFormat:@"%ld小时前",(long)sub/60/60];
    }
    
    if (sub>60*60*24&&sub<60*60*24*7) {
        reFormat = [NSString stringWithFormat:@"%ld天前",(long)sub/60/60/24];
    }
    
    if (sub>60*60*24*7) {
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateStyle:NSDateFormatterMediumStyle];
        [f setTimeStyle:NSDateFormatterShortStyle];
        [f setDateFormat:@"YYYY"];
        
        NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
        [f2 setDateStyle:NSDateFormatterMediumStyle];
        [f2 setTimeStyle:NSDateFormatterShortStyle];
        [f2 setDateFormat:@"MM月dd日"];
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.integerValue];
        NSString *str1= [f stringFromDate:confromTimesp];
        NSString *str2 =[f stringFromDate:[NSDate dateWithTimeIntervalSince1970:now]];
        if ([str1 isEqualToString:str2]) {
            reFormat = [f2 stringFromDate:confromTimesp];
        }else{
            reFormat =[formatter stringFromDate:confromTimesp];
        }
    }
    return reFormat;
}

/**
 *  数量转换
 */
-(NSString *)getShotCount{
    NSInteger times = self.integerValue;
    NSInteger tenThousand = 10000;
    if (times < tenThousand) {
        return [NSString stringWithFormat:@"%zd", times];
    }
    NSInteger thousand = 1000;
    NSInteger left = times % thousand;
    times = (times - left) / thousand;
    // < 1M, 99.9W
    //    if (times < 999.5f) {
    if (times < 999) {
        if (left >= 0) {
            times += 1;
        }
        return [NSString stringWithFormat:@"%.1f万", times / 10.f];
    }
    // < 100M 9999W
    //    if (times < 99995.f) {
    if (times < 99990) {
        times /= 10;
        if (left >= 0) {
            times += 1;
        }
        return [NSString stringWithFormat:@"%zd万", times];
    }
    // >= 100M, 1.1
    left = times % tenThousand;
    times = (times - left) / tenThousand;
    if (left >= 0) {
        times += 1;
    }
    return [NSString stringWithFormat:@"%.1f亿", times / 10.f];
}

+ (NSInteger)lengthForString:(NSString*)string {
    NSInteger len = 0;
    char* p = (char*)[string cStringUsingEncoding:NSUnicodeStringEncoding];
    NSInteger totalLen = [string lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
    NSLog(@"Total: %zd", totalLen);
    for (NSInteger i = 0; i< totalLen; i++) {
        NSLog(@"char %d", *p);
        if (*p++) {
            NSLog(@"++len");
            ++len;
        }
    }
    return (len + 1) / 2;
}

+ (NSString *)fileSizeStringFromBytes:(uint64_t)byteSize {
    if (kCommonUtilsGigabyte <= byteSize) {
        return [NSString stringWithFormat:@"%@GB", [self numberStringFromDouble:(double)byteSize / kCommonUtilsGigabyte]];
    }
    if (kCommonUtilsMegabyte <= byteSize) {
        return [NSString stringWithFormat:@"%@MB", [self numberStringFromDouble:(double)byteSize / kCommonUtilsMegabyte]];
    }
    if (kCommonUtilsKilobyte <= byteSize) {
        return [NSString stringWithFormat:@"%@KB", [self numberStringFromDouble:(double)byteSize / kCommonUtilsKilobyte]];
    }
    return [NSString stringWithFormat:@"%zd.0B", byteSize];
}

+ (NSString *)numberStringFromDouble:(const double)num {
    NSInteger section = round((num - (NSInteger)num) * 100);
    if (section % 10) {
        return [NSString stringWithFormat:@"%.2f", num];
    }
    if (section > 0) {
        return [NSString stringWithFormat:@"%.1f", num];
    }
    return [NSString stringWithFormat:@"%.0f", num];
}

+ (BOOL)specialCharInString:(NSString *)str {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" ,.?:~`\"'[{]}|\\><"];
    NSRange range = [str rangeOfCharacterFromSet:set];
    return range.location != NSNotFound;
}
+ (NSString *)stringForDate:(NSDate *)date {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.locale = [NSLocale currentLocale];
    formater.dateFormat = @"yyyy年M月d日";
    return [formater stringFromDate:date];
}
+ (NSString *)stringForTimeStamp:(NSTimeInterval)ts {
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:ts];
    return [self stringForDate:date];
}
+ (NSString *)todayStringForDate:(NSDate *)aDate
{
    //    当天：采用24h制，如 20:26
    //    昨天：只显示日期“昨天”
    //    前天及更早的时间（今年）：显示月、日，如12月11日
    //    去年及更早的时间：显示年、月、日，如2012年11月5日
    //    分钟补0
    
    NSDate *today = [NSDate date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:0];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:aDate];
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    NSDateComponents *yesterdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:yesterday];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day)
    {
        formater.dateFormat = @"H:mm";
        return [formater stringFromDate:aDate];
    } else if (dateComponents.year == yesterdayComponents.year && dateComponents.month == yesterdayComponents.month && dateComponents.day == yesterdayComponents.day)
    {
        return @"昨天";
    } else if(dateComponents.year == todayComponents.year)
    {
        formater.dateFormat = @"M-d";
        return [NSString stringWithFormat:@"%ld月%ld日",dateComponents.month,dateComponents.day];
    }else
    {
        formater.dateFormat = @"yyyy-M-d";
        return [NSString stringWithFormat:@"%ld年%ld月%ld日",dateComponents.year,dateComponents.month,dateComponents.day];
    }
}
+ (NSString *)stringForNSDate:(NSDate *)date
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.locale = [NSLocale currentLocale];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formater stringFromDate:date];
}

+ (NSDate *)dateForNSString:(NSString *)aString
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.locale = [NSLocale currentLocale];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formater dateFromString:aString];
}
+ (NSDate *)dateForNSStringForGMT:(NSString *)aString
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    formater.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    return [formater dateFromString:aString];
}

+ (NSArray *)separatedByString:(NSString *)orginString string:(NSString *)string{

    if ([orginString rangeOfString:string].location != NSNotFound) {
        return [orginString componentsSeparatedByString:string];
    }
    else{
    
        return nil;
    }
}

+ (NSString *)getSunString:(NSString *)orginString Loc:(NSInteger)loc length:(NSInteger)length{
    if (loc + length> orginString.length) {
        return nil;
    }
    return [orginString substringWithRange:NSMakeRange(loc, length)];
}
+ (NSString *)getDayTime:(double)beTime
{
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    distanceStr = [df stringFromDate:beDate];
    return distanceStr;
}

+ (NSString *)documentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString *)createDirectoryInDocument:(NSString *)aDirectoryName
{
    NSString *path = [[NSString documentDirectory] stringByAppendingPathComponent:aDirectoryName];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return path;
}

+ (BOOL)isValidPhoneNumber:(NSString *)number {
    if (number.length != 11) {
        return NO;
    }
    NSString *regex = @"^1\\d{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:number];
}

+ (BOOL)isValidPassword:(NSString *)password {
    return password.length >= 6 && password.length <= 16;
}

+ (BOOL)isValidVerifyCode:(NSString *)verifyCode {
    if (verifyCode.length != 4) {
        return NO;
    }
    NSString *regex = @"^\\d{4}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:verifyCode];
}


+ (BOOL)isValidPictureCode:(NSString *)pictureCode{
    
    if (pictureCode.length != 4) {
        return NO;
    }
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:pictureCode];

}


+ (NSString *)getTime:(NSString *)shijianchuo {
    
    NSString *str=shijianchuo ;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    NSDate*nowdate=[NSDate date];

    NSTimeInterval timeval1=[nowdate timeIntervalSinceDate:detaildate];
    if(timeval1<3*60) {
    
        return @"刚刚";
    }
    
    return currentDateStr;
}
+(NSString *)getIdentifier {
    
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return identifierForVendor;
}

/**
 *  获取label每行文字
 *
 *  @return array
 */
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text] ? : @"";
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}


@end
