//
//  PostModel.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/22.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel

@end

@implementation PostImageModel
-(instancetype)initWithImage:(UIImage*)image imageName:(NSString*)imageName{
    if (self = [super init]) {
        self.image = image;
        self.imageName = imageName;
    }
    return self;
}
@end
