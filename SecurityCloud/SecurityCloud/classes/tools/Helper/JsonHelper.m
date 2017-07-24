//
//  JsonHelper.m
//  SecurityCloud
//
//  Created by apple on 2017/7/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "JsonHelper.h"

@implementation JsonHelper
+(NSString *)jsonWithObj:(id)obj{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:NULL];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    jsonStr = [jsonStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    jsonStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)jsonStr, NULL, (CFStringRef)@"!*’();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
//    NSMutableString *responseString = [NSMutableString stringWithString:jsonStr];
//    NSString *character = nil;
//    for (int i = 0; i < responseString.length; i ++) {
//            character = [responseString substringWithRange:NSMakeRange(i, 1)];
//            if ([character isEqualToString:@"\\"])
//            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
//    }
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    return jsonStr;
}
@end
