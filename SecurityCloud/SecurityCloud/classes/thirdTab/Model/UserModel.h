//
//  UserModel.h
//  SecurityCloud
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic,strong) UserModel *admin;
@property (nonatomic,strong) NSArray<UserLabel*> *biaoqian;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *numrow;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,strong) UserModel *shangxian;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *imgurl;

@end
