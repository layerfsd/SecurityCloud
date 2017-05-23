//
//  UserManager.m
//  SecurityCloud
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "UserManager.h"
#import "LoginNavigationController.h"
@implementation UserManager

static UserManager *manager;

+(UserManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [UserManager new];
    });
    return manager;
}

MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userID":@"id"};
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
    BOOL result = [data writeToFile:path atomically:YES];
    if (result) {
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
    [self initShare:user];
    
    return user;
}

+(void)initShare:(UserManager*)user {
    [UserManager sharedManager].userID = user.userID;
    [UserManager sharedManager].name = user.name;
    [UserManager sharedManager].password = user.password;
    [UserManager sharedManager].tel = user.tel;
    [UserManager sharedManager].time = user.time;
    [UserManager sharedManager].biaoqian = user.biaoqian;
}

//主页
-(void)goToMain {
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseNavigationController *nv = [mainSb instantiateViewControllerWithIdentifier:@"BaseNavigationController"];
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

@end


@implementation UserLabel
MJCodingImplementation
@end
