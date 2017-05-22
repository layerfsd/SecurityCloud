//
//  Md5Util.h
//  GreateDragenPad
//
//  Created by alanzhangg on 15-2-10.
//  Copyright (c) 2015年 jl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface Md5Util : NSObject
{
    
}
// 加密方法
+ (NSString*)encryptMD5:(NSString*)plainText;
@end
