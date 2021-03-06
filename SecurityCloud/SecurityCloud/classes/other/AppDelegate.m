//
//  AppDelegate.m
//  SecurityShield
//
//  Created by apple on 17/5/20.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "AppDelegate.h"
#import "QAppKeyCheck.h"
#import <TencentLBS/TencentLBS.h>
#import "DHGuidePageHUD.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "MsgListViewController.h"
@interface AppDelegate ()<QAppKeyCheckDelegate,TencentLBSLocationManagerDelegate,JPUSHRegisterDelegate>
@property (strong, nonatomic) TencentLBSLocationManager *locationManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Model"];
    
    self.keyCheck = [[QAppKeyCheck alloc] init];
    [self.keyCheck start:@"BIIBZ-EOBAS-6CFOT-624LR-G7N3K-Q3BHD" withDelegate:self];
   
    
   
    [self.window makeKeyAndVisible];
    
    [self appVersion];
    
    [self configLocationManager];
    
    [self APNs];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"af55afec821a3f02ad0013c3"
                          channel:@""
                 apsForProduction:NO];
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"592114144ad15673c0000766"];
    
//    [self configUSharePlatforms];
    
    [self configUSharePlatforms];
    
    
    UserManager *user = [UserManager unArchiver];
    
    if (user) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JPUSHService setTags:nil alias:UserID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"%d-------------%@,-------------%@",iResCode,iTags,iAlias);
            }];
        });
        //有帐户 直接登录
        [user goToMain];
    }else{
        [[UserManager new] goToLogin];
    }
    return YES;
}


- (void)configUSharePlatforms
{
        /* 设置微信的appKey和appSecret */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx0982005eb18945a9" appSecret:@"30a5fa2881bda2c939e08ce6c655ee83" redirectURL:[NSString stringWithFormat:@"%@%@",advertiseUrl,UserID]];
        /*
         * 移除相应平台的分享，如微信收藏
         */
        //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
        
        /* 设置分享到QQ互联的appID
         * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
         */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106192972"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

-(void)APNs{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
   
}

-(void)appVersion {
    NSString* app_version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    //获取到完整的版本号
    //获取沙盒中存储的应用的版本号
    NSString* save_version = [[NSUserDefaults standardUserDefaults]stringForKey:@"save_version"];
    
    if ([app_version isEqualToString:save_version]) {
        //不是第一次进入 或者 升级后  不是第一次进入
        
    }else{
        
        //第一次进入 或者 升级后第一次进入
        [[NSUserDefaults standardUserDefaults] setObject:app_version forKey:@"save_version"];
        [[NSUserDefaults standardUserDefaults]synchronize]; //确保数据操作同步执行
//        NSArray *imageArray = @[@"完成",@"完成",@"完成",@"完成",@"完成"];
//        DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.window.frame imageNameArray:imageArray buttonIsHidden:NO];
//        [self.window addSubview:guidePage];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];   //清除角标
    [application cancelAllLocalNotifications];
    [self.locationManager startUpdatingLocation];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support 在前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"有新消息，立即查看？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
          [self goToMsgVc:userInfo];
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
  
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support 在后台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [self goToMsgVc:userInfo];
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    [self goToMsgVc:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    [self goToMsgVc:userInfo];
}

-(void)goToMsgVc:(NSDictionary*)msgDic{
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@"push"forKey:@"push"];
    [pushJudge synchronize];
//    NSString * targetStr = [msgDic objectForKey:@"target"];
//    if ([targetStr isEqualToString:@"notice"]) {
        MsgListViewController * VC = [[MsgListViewController alloc]init];
        UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:VC];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
        [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
        
//    }
}

// 这是QAppKeyCheckDelegate提供的key验证回调，用于检查传入的key值是否合法
-(void)notifyAppKeyCheckResult:(QErrorCode)errCode
{
    if (errCode == QErrorNone) {
        NSLog(@"验证成功");
    }
}

- (void)configLocationManager
{
    self.locationManager = [[TencentLBSLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setApiKey:@"BIIBZ-EOBAS-6CFOT-624LR-G7N3K-Q3BHD"];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    // 需要后台定位的话，可以设置此属性为YES。
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    
    // 如果需要POI信息的话，根据所需要的级别来设定，定位结果将会根据设定的POI级别来返回，如：
    [self.locationManager setRequestLevel:TencentLBSRequestLevelName];
    
    // 申请的定位权限，得和在info.list申请的权限对应才有效
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

//- (void)startSingleLocation {
//    [self.locationManager requestLocationWithCompletionBlock:
//     ^(TencentLBSLocation *location, NSError *error) {
//        NSLog(@"%@, %@, %@", location.location, location.name, location.address);
//     }];
//}

- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager
                 didFailWithError:(NSError *)error {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusDenied ||
        authorizationStatus == kCLAuthorizationStatusRestricted) {
       
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"定位权限未开启，是否开启？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"是"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    if( [[UIApplication sharedApplication]canOpenURL:
                                                         [NSURL URLWithString:UIApplicationOpenSettingsURLString]] ) {
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
                                                        [[UIApplication sharedApplication]openURL:[NSURL
                                                                                                   URLWithString:UIApplicationOpenSettingsURLString]
                                                                                          options:@{}completionHandler:^(BOOL success) {
                                                                                          }];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
                                                        [[UIApplication sharedApplication] openURL:
                                                         [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
#endif
                                                    }
                                                }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"否"
                                                  style:UIAlertActionStyleDefault 
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                }]];
        
        [self.window.rootViewController presentViewController:alert animated:true completion:nil];
        
    } else {
        
    }
}

- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager
                didUpdateLocation:(TencentLBSLocation *)location {
    //定位结果
//    NSLog(@"location:%@", location.location);
    [UserManager sharedManager].address = location.address;
    [UserManager sharedManager].location = [NSString stringWithFormat:@"%f,%f",location.location.coordinate.latitude,location.location.coordinate.longitude];
    
    [UserManager sharedManager].latitude = [NSString stringWithFormat:@"%f",location.location.coordinate.latitude];
    [UserManager sharedManager].longitude = [NSString stringWithFormat:@"%f",location.location.coordinate.longitude];
    
    [self upLocation:[NSString stringWithFormat:@"%f,%f",location.location.coordinate.latitude,location.location.coordinate.longitude]];
    [self.locationManager stopUpdatingLocation];
}

-(void)upLocation:(NSString*)zuobiao {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:UserID forKey:@"id"];
    [parameters setValue:zuobiao forKey:@"zuobiao"];
    
    [HttpTool postWithoutProgress:@"/api/qingbaoyuandizhi.html" parameters:parameters success:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

@end
