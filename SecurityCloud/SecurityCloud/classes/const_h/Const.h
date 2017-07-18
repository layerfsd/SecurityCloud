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
#define TestPath @"http://cntp31.lysoo.com/guanli/index.php/Api/"
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
#define webUrl @"http://112.99.194.54:2166/guanli/index.php/admin/zxgl/zixunweburl/id/"
#define advertiseUrl @"http://112.99.194.54:2166/guanli/index.php/Admin/yaoqing/zhuceyaoqing/yaoqingid/"

#define updateUrl @"itms-apps://itunes.apple.com/cn/app/%E9%BE%99%E9%98%B2%E4%BA%91/id1244627465?mt=8"

#define shareContent @"实现社会维稳信息全采集，自动实施信息存档、分析、研判、流转、预警、管理等十大功能，是专业信息综管平台"
//const
#define cellNum 10
#endif /* Const_h */
