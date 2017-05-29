//
//  MoreMsgListTableViewCell.h
//  SecurityCloud
//
//  Created by apple on 17/5/28.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MsgLitterModel;
@interface MoreMsgListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) MsgLitterModel *model;
@end
