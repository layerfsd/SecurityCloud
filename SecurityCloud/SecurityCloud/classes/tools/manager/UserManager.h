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
@property (nonatomic,copy) NSArray<UserLabel *> *biaoqian;

+(UserManager *)sharedManager;

-(void)archiver;
+(UserManager*)unArchiver;

-(void)goToMain;
-(void)goToLogin;


+(void)setTelNum:(NSString*)tel;
+(NSString*)getTelNum;
@end

//标签
@interface UserLabel : NSObject
@property (nonatomic,copy) NSString *labelID;
@property (nonatomic,copy) NSString *biaoti;
@property (nonatomic,copy) NSString *beizhu;
//标签绑定的时间
@property (nonatomic,copy) NSString *time;

@end
