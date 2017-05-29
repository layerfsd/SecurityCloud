//
//  UserModel.m
//  SecurityCloud
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"userID":@"id"};
}

+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"biaoqian" : @"UserLabel",
             };
}

@end
