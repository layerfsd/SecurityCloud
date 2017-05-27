//
//  MeHeadTableViewCell.h
//  SecurityCloud
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@protocol MeHeadTableViewCellDelegate <NSObject>

-(void)QRClicked;

@end
@interface MeHeadTableViewCell : UITableViewCell
@property (nonatomic,strong) UserModel *model;
@property (nonatomic,weak)id <MeHeadTableViewCellDelegate> delegate;
@end
