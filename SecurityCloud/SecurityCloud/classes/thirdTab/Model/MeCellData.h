//
//  MeCellData.h
//  SecurityCloud
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeCellData : NSObject
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *imageName;

+(instancetype)initWithTitle:(NSString*)title imageName:(NSString*)imageName;
@end