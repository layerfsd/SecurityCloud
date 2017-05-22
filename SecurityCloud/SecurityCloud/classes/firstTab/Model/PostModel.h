//
//  PostModel.h
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/22.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostModel : NSObject
//主内容
@property (nonatomic, copy) NSString *contentStr;
//图片数组
@property (nonatomic, copy) NSMutableArray *images;
//录音保存路径
@property (nonatomic, copy) NSString *recordUrl;

@end


@interface PostImageModel : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageName;


-(instancetype)initWithImage:(UIImage*)image imageName:(NSString*)imageName;
@end
