//
//  Info+CoreDataProperties.h
//  SecurityCloud
//
//  Created by apple on 17/5/22.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "Info.h"
#import "PostModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Info (CoreDataProperties)

+ (NSFetchRequest<Info *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, retain) NSString *images;
@property (nullable, nonatomic, copy) NSString *voicePath;

@end

NS_ASSUME_NONNULL_END
