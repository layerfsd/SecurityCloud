//
//  AppDelegate.h
//  SecurityShield
//
//  Created by apple on 17/5/20.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QAppKeyCheck;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) QAppKeyCheck *keyCheck;
@end

