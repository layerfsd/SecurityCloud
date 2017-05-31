//
//  RankingTableViewCell.h
//  SecurityCloud
//
//  Created by apple on 17/5/30.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@interface RankingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


@property (nonatomic,strong) UserModel *model;
@end
