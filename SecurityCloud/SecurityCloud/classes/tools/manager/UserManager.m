//
//  UserManager.m
//  SecurityCloud
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "UserManager.h"
#import "LoginNavigationController.h"
#import "JPUSHService.h"
@implementation UserManager



+(UserManager *)sharedManager {
    static UserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"userID":@"id"};
}

+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"biaoqian" : @"UserLabel",
             @"biaoqian2" : @"UserLabel",
             };
}

//归档
-(void)archiver {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    
    path = [path stringByAppendingPathComponent:@"singeUser.txt"];
    //1:准备存储数据的对象
    NSMutableData *data = [NSMutableData data];
    //2:创建归档对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //3:开始归档
    [archiver encodeObject:self forKey:@"UserManager"];
    //4:完成归档
    [archiver finishEncoding];
    //5:写入文件当中
    [[UserManager sharedManager] initShare:self];
    BOOL result = [data writeToFile:path atomically:YES];
    
    if (result) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JPUSHService setTags:nil alias:UserID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"%d-------------%@,-------------%@",iResCode,iTags,iAlias);
            }];
        });
        NSLog(@"归档成功:%@",path);
    }else
    {
        NSLog(@"归档不成功!!!");
    }
}
//解档
+(UserManager*)unArchiver {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    
    path = [path stringByAppendingPathComponent:@"singeUser.txt"];
    
    NSData *myData = [NSData dataWithContentsOfFile:path];
    //创建反归档对象
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:myData];
    //反归档
    UserManager *user = [UserManager new];
    user = [unarchiver decodeObjectForKey:@"UserManager"];
    //完成反归档
    [unarchiver finishDecoding];
    
    //解档完需要初始化单例
    [[UserManager sharedManager] initShare:user];
    [JPUSHService setAlias:UserID callbackSelector:nil object:self];
    return user;
}

-(void)initShare:(UserManager*)user {
    [UserManager sharedManager].userID = user.userID;
    [UserManager sharedManager].name = user.name;
    [UserManager sharedManager].password = user.password;
    [UserManager sharedManager].tel = user.tel;
    [UserManager sharedManager].time = user.time;
    [UserManager sharedManager].biaoqian = user.biaoqian;
    [UserManager sharedManager].admin = user.admin;
    [UserManager sharedManager].shangxian = user.shangxian;
    [UserManager sharedManager].imgurl = user.imgurl;


}

//主页
-(void)goToMain {
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseNavigationController *nv = [mainSb instantiateViewControllerWithIdentifier:@"BaseTabBarController"];
    appDelegate.window.rootViewController = nv;
}
//登录
-(void)goToLogin {
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginNavigationController *nv = [mainSb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    appDelegate.window.rootViewController = nv;
}

//储存电话号码
+(void)setTelNum:(NSString*)tel {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:tel forKey:@"tel"];
    [userDefault synchronize];

}
//获取电话号码
+(NSString*)getTelNum {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return (NSString*)[userDefault stringForKey:@"tel"];
}

//储存地址
-(void)setAddress:(NSString*)address {
    _address = address;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:address forKey:@"address"];
    [userDefault synchronize];
}
//获取地址
-(NSString*)getAddress {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return (NSString*)[userDefault stringForKey:@"address"];
}



//储存经纬度
-(void)setLocation:(NSString*)location {
    _location = location;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:location forKey:@"location"];
    [userDefault synchronize];
    
}
//获取经纬度
-(NSString*)getLocation {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return (NSString*)[userDefault stringForKey:@"location"];
}


+ (BOOL)deleteFile
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    
    path = [path stringByAppendingPathComponent:@"singeUser.txt"];
    // 获取要删除的路径
   
    // 创建文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    // 删除
    BOOL isDelete = [manager removeItemAtPath:path error:nil];
    return isDelete;
}
@end


@implementation UserLabel
MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"labelID":@"id"};
}
@end
