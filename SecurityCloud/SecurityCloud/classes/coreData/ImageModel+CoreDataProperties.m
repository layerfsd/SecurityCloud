//
//  ImageModel+CoreDataProperties.m
//  SecurityCloud
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "ImageModel+CoreDataProperties.h"

@implementation ImageModel (CoreDataProperties)

+ (NSFetchRequest<ImageModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ImageModel"];
}

@dynamic imageData;
@dynamic imageName;

@end
