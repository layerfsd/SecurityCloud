//
//  PostModel.h
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/22.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FileModel;
@class FlowModel;
@interface PostModel : NSObject

@property (nonatomic, copy) NSString *biaoti;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSArray<FileModel*> *luyinchakan;
@property (nonatomic, copy) NSString *numrow;
@property (nonatomic, strong) UserManager *yonghu;
@property (nonatomic, copy) NSString *fenlei;
@property (nonatomic, strong) NSArray<NSString*> *img;
@property (nonatomic, copy) NSString *yonghuname;
@property (nonatomic, copy) NSString *leibie;
@property (nonatomic, copy) NSString *jibie;
@property (nonatomic, copy) NSString *neirong;
@property (nonatomic, copy) NSString *zuobiao;
@property (nonatomic, copy) NSString *leibieid;
@property (nonatomic, copy) NSString *guanjianzi;
@property (nonatomic, copy) NSString *luyin;
@property (nonatomic, copy) NSString *yanse;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSArray<FileModel*> *imgchakan;
@property (nonatomic, copy) NSString *guanjianzineirong;
@property (nonatomic, copy) NSString *jifen;
@property (nonatomic, copy) NSString *dizhi;
@property (nonatomic, copy) NSString *yonghuid;
@property (nonatomic, copy) NSString *zhuangtai;
@property (nonatomic, copy) NSString *neirongchakan;
@property (nonatomic, copy) NSString *guanjianzichakan;

@property (nonatomic, strong) NSArray<FlowModel*> *banliliucheng;


@end


@interface FileModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *geshi;
@property (nonatomic, copy) NSString *numrow;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *fenlei;
@property (nonatomic, copy) NSString *time;
@end

@interface PostImageModel : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageName;



-(instancetype)initWithImage:(UIImage*)image imageName:(NSString*)imageName;
@end

@interface FlowModel : NSObject
@property (nonatomic, copy) NSString *numrow;
@property (nonatomic, copy) NSString *qingbaozhuangtai;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *flowID;
@property (nonatomic, copy) NSString *neirong;
@property (nonatomic, copy) NSString *jifen;
@property (nonatomic, copy) NSString *zhuangtai;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *name;


@end
