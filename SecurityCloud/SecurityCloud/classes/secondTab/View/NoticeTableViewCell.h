//
//  NoticeTableViewCell.h
//  SecurityCloud
//
//  Created by apple on 17/5/27.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>



@class NoticeModel;
@protocol MsgClikedDelegate <NSObject>

-(void)msgCliked:(NSString*)msgID;

@end

@protocol MoreMsgClickedDelegate <NSObject>

-(void)moreMsgClicked:(NSString*)msgID;

@end

@interface NoticeTableViewCell : UITableViewCell
@property (nonatomic,strong) NoticeModel *model;

@property (nonatomic,weak) id<MsgClikedDelegate> delegate;

@property (nonatomic,weak) id<MoreMsgClickedDelegate> actionDelegate;
@end
