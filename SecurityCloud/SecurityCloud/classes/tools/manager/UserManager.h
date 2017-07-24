//
//  UserManager.h
//  SecurityCloud
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserLabel;
@interface UserManager : NSObject
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,strong) NSArray<UserLabel *> *biaoqian;
@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *latitude;

@property (nonatomic,copy) NSString *imgurl;
@property (nonatomic,strong) UserManager *shangxian;
@property (nonatomic,strong) UserManager *admin;
@property (nonatomic,assign) float jifen;
@property (nonatomic,strong) NSArray<UserLabel *> *biaoqian2;
+(UserManager *)sharedManager;

-(void)archiver;
+(UserManager*)unArchiver;

-(void)goToMain;
-(void)goToLogin;


+(void)setTelNum:(NSString*)tel;
+(NSString*)getTelNum;

-(void)initShare:(UserManager*)user;
//+(void)setAddress:(NSString*)address;
//+(NSString*)getAddress;
//
//+(void)setLocation:(NSString*)location;
//+(NSString*)getLocation;
+ (BOOL)deleteFile;


@end

//标签
@interface UserLabel : NSObject
@property (nonatomic,copy) NSString *labelID;
@property (nonatomic,copy) NSString *biaoti;
@property (nonatomic,copy) NSString *beizhu;
//标签绑定的时间
@property (nonatomic,copy) NSString *time;

@end
