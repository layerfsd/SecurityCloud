//
//  Info+CoreDataProperties.m
//  SecurityCloud
//
//  Created by apple on 2017/7/18.
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
@dynamic videoPath;
@dynamic voicePath;
@dynamic videoImagePath;

@end
