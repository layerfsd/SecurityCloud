//
//  ImageModel+CoreDataProperties.h
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/25.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "ImageModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ImageModel (CoreDataProperties)

+ (NSFetchRequest<ImageModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, retain) NSData *imageData;

@end

NS_ASSUME_NONNULL_END
