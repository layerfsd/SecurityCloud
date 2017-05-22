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

MJCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userID":@"id"};
}

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
    return user;
}

-(void)goToMain {
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseNavigationController *nv = [mainSb instantiateViewControllerWithIdentifier:@"BaseNavigationController"];
    appDelegate.window.rootViewController = nv;
}

-(void)goToLogin {
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginNavigationController *nv = [mainSb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    appDelegate.window.rootViewController = nv;
}

+(void)setTelNum:(NSString*)tel {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:tel forKey:@"tel"];
    [userDefault synchronize];

}
+(NSString*)getTelNum {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return (NSString*)[userDefault stringForKey:@"tel"];
}

@end


@implementation UserLabel
MJCodingImplementation
@end
