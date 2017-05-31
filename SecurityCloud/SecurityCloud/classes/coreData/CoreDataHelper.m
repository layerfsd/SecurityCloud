//
//  CoreDataHelper.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/25.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "CoreDataHelper.h"
#import "Info+CoreDataClass.h"
@implementation CoreDataHelper
+(NSArray *)getInfos {
    
    NSArray *sortedInfos = [Info MR_findByAttribute:@"userID" withValue:UserID andOrderBy:@"creatTime" ascending:YES];
    return sortedInfos;
}

+(Info *)findInfoByTime:(NSDate*)time {
    NSArray *sortedInfos = [Info MR_findByAttribute:@"creatTime" withValue:time];
    return sortedInfos.firstObject;
}
@end
