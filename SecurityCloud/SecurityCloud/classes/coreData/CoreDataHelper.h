//
//  CoreDataHelper.h
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/25.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Info;
@interface CoreDataHelper : NSObject
+(NSArray*)getInfos;
+(Info *)findInfoByTime:(NSDate*)time;
@end
