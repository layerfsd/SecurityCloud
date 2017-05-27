//
//  MsgModel.m
//  SecurityCloud
//
//  Created by apple on 17/5/27.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MsgModel.h"
@implementation MsgLitterModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"msgLitterID":@"id"};
}


@end

@implementation NoticeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"noticeID":@"id"};
}

+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"zixunliebiao" : @"MsgLitterModel",
             };
}

@end



@implementation MsgModel
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"liebiao" : @"NoticeModel",
             };
}
@end
