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
@interface AppDelegate ()<QAppKeyCheckDelegate,TencentLBSLocationManagerDelegate>
@property (strong, nonatomic) TencentLBSLocationManager *locationManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Model.sqlite"];
    self.keyCheck = [[QAppKeyCheck alloc] init];
    [self.keyCheck start:@"BIIBZ-EOBAS-6CFOT-624LR-G7N3K-Q3BHD" withDelegate:self];
    UserManager *user = [UserManager unArchiver];
    if (user) {
        //有帐户 直接登录
        [user goToMain];
    }
    [self configLocationManager];
    [self startSingleLocation];
    
    return YES;
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
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
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
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    // 如果需要POI信息的话，根据所需要的级别来设定，定位结果将会根据设定的POI级别来返回，如：
    [self.locationManager setRequestLevel:TencentLBSRequestLevelName];
    
    // 申请的定位权限，得和在info.list申请的权限对应才有效
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)startSingleLocation {
    [self.locationManager requestLocationWithCompletionBlock:
     ^(TencentLBSLocation *location, NSError *error) {
         NSLog(@"%@, %@, %@", location.location, location.name, location.address);
     }];
}

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
    NSLog(@"location:%@", location.location);
    [self.locationManager stopUpdatingLocation];
}

@end
