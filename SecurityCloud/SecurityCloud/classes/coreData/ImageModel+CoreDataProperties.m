//
//  ImageModel+CoreDataProperties.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/25.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "ImageModel+CoreDataProperties.h"

@implementation ImageModel (CoreDataProperties)

+ (NSFetchRequest<ImageModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ImageModel"];
}

@dynamic imageName;
@dynamic imageData;

@end
