//
//  NoticeTableViewCell.h
//  SecurityCloud
//
//  Created by apple on 17/5/27.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoticeModel;
@interface NoticeTableViewCell : UITableViewCell
@property (nonatomic,strong) NoticeModel *model;
@end