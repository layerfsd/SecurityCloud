//
//  MsgCenterModel.m
//  SecurityCloud
//
//  Created by apple on 17/5/30.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "MsgCenterModel.h"

@implementation MsgCenterModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"msgID":@"id"};
}
@end
