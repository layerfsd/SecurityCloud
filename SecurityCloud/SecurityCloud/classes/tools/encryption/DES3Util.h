//
//  DES3Util.h
//  ShangMenBang
//
//  Created by jwCai on 14/12/18.
//  Copyright (c) 2014年 jwCai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;

@end
