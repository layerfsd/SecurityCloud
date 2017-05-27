//
//  MsgModel.h
//  SecurityCloud
//
//  Created by apple on 17/5/27.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

//item
@interface MsgLitterModel : NSObject
@property (nonatomic,copy) NSString *msgLitterID;
@property (nonatomic,copy) NSString *fenleiid;
@property (nonatomic,copy) NSString *fenlei;

@property (nonatomic,copy) NSString *biaoti;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *adminid;
@property (nonatomic,copy) NSString *admin;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *numrow;
@end

//公告
@interface NoticeModel : NSObject
@property (nonatomic,copy) NSString *noticeID;
@property (nonatomic,copy) NSString *tubiao;
@property (nonatomic,copy) NSString *biaoti;
@property (nonatomic,copy) NSString *paixu;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *numrow;
@property (nonatomic,copy) NSArray<MsgLitterModel*> *zixunliebiao;
@end

//整个json
@interface MsgModel : NSObject
@property (nonatomic,strong) NoticeModel *gonggao;
@property (nonatomic,copy) NSArray<NoticeModel*> *liebiao;
@end



