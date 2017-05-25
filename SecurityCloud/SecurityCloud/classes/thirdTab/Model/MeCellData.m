//
//  MeCellData.m
//  SecurityCloud
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MeCellData.h"

@implementation MeCellData
+(instancetype)initWithTitle:(NSString*)title imageName:(NSString*)imageName{
    MeCellData *meCellData = [[MeCellData alloc] init];
    meCellData.titleStr = title;
    meCellData.imageName = imageName;
    return meCellData;
}
@end
