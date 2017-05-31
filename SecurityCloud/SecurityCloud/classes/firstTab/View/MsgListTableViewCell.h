//
//  MsgListTableViewCell.h
//  SecurityCloud
//
//  Created by apple on 17/5/30.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MsgCenterModel;
@interface MsgListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong) MsgCenterModel *model;
@end
