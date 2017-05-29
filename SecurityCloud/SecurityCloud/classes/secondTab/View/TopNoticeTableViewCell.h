//
//  TopNoticeTableViewCell.h
//  SecurityCloud
//
//  Created by apple on 17/5/27.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoticeModel;
@protocol MsgClikedDelegate;
@interface TopNoticeTableViewCell : UITableViewCell
@property (nonatomic,strong) NoticeModel *model;

@property (nonatomic,weak) id<MsgClikedDelegate> delegate;
@end
