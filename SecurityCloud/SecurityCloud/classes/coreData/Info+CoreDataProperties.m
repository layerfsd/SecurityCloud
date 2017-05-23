//
//  Info+CoreDataProperties.m
//  SecurityCloud
//
//  Created by apple on 17/5/22.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "Info+CoreDataProperties.h"

@implementation Info (CoreDataProperties)

+ (NSFetchRequest<Info *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Info"];
}

@dynamic content;
@dynamic images;
@dynamic voicePath;

@end
