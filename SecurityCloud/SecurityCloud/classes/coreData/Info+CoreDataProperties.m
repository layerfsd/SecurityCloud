//
//  Info+CoreDataProperties.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/25.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "Info+CoreDataProperties.h"

@implementation Info (CoreDataProperties)

+ (NSFetchRequest<Info *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Info"];
}

@dynamic content;
@dynamic creatTime;
@dynamic images;
@dynamic userID;
@dynamic voicePath;

@end
