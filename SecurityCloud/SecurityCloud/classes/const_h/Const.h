//
//  Const.h
//  SecurityShield
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#ifndef Const_h
#define Const_h
//api 前部
//#define RootPath @"http://cntp31.lysoo.com/guanli/index.php/admin/api"
#define RootPath @"http://112.99.194.54:2166/guanli/index.php/admin/api"
#define UserID [UserManager sharedManager].userID

#define navColor [UIColor colorWithRed:16.0/255 green:106.0/255 blue:219.0/255 alpha:1]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define appDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)



//notification
#define DraftBoxListViewControllerNotificationString @"DraftBoxListViewControllerNotificationString"
#define PostedListViewControllerNotificationString @"PostedListViewControllerNotificationString"
#define FirstViewControllerReload @"FirstViewControllerReload"
#define MyDetailViewControllerReload @"MyDetailViewControllerReload"
#define AdminHanderListViewControllerReload @"AdminHanderListViewControllerReload"

#define MsgListViewControllerReload @"MsgListViewControllerReload"

//webView
#define webUrl @"http://cntp31.lysoo.com/guanli/index.php/admin/zxgl/zixunweburl/id/"
#define advertiseUrl @"http://cntp31.lysoo.com/guanli/index.php/Admin/yaoqing/zhuceyaoqing/yaoqingid/"

//const
#define cellNum 10
#endif /* Const_h */
