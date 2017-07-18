//
//  ImageModel+CoreDataProperties.h
//  SecurityCloud
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "ImageModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ImageModel (CoreDataProperties)

+ (NSFetchRequest<ImageModel *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, copy) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
