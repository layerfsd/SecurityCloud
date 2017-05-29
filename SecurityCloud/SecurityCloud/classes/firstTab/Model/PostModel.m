//
//  PostModel.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/22.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel
MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID":@"id"};
}

+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"luyinchakan" : @"FileModel",
             };
}

@end

@implementation FileModel
MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID":@"id"};
}
@end

@implementation PostImageModel

MJCodingImplementation

-(instancetype)initWithImage:(UIImage*)image imageName:(NSString*)imageName{
    if (self = [super init]) {
        self.image = image;
        self.imageName = imageName;
    }
    return self;
}
@end
