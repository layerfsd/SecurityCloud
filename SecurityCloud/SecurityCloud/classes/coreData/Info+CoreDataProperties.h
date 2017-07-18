//
//  Info+CoreDataProperties.h
//  SecurityCloud
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "Info+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Info (CoreDataProperties)

+ (NSFetchRequest<Info *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *creatTime;
@property (nullable, nonatomic, copy) NSString *images;
@property (nullable, nonatomic, copy) NSString *userID;
@property (nullable, nonatomic, copy) NSString *videoPath;
@property (nullable, nonatomic, copy) NSString *voicePath;
@property (nullable, nonatomic, copy) NSString *videoImagePath;

@end

NS_ASSUME_NONNULL_END
