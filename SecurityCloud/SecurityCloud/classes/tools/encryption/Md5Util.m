//
//  Md5Util.m
//
//
//

#import "Md5Util.h"


@interface Md5Util ()

@end

@implementation Md5Util




+ (NSString*)encryptMD5:(NSString*)string{
    
    const char *cStr = [string UTF8String];
    
    unsigned char result[32];
    
    CC_MD5( cStr, strlen(cStr),result );
    
    NSMutableString *hash =[NSMutableString string];
    
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
    
}

@end
