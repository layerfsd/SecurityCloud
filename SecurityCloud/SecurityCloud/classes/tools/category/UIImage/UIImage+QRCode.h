//
//  UIImage+QRCode.h
//  SecurityCloud
//
//  Created by apple on 17/5/28.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRCode)
+(UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize logo:(UIImage*)logoImage;
@end
