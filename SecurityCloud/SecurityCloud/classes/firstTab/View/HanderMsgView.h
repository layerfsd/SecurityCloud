//
//  HanderMsgView.h
//  SecurityCloud
//
//  Created by apple on 17/5/29.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HanderMsgViewDoneBlock)(NSString *valueStr,BOOL isPush,NSString *contentStr);
@interface HanderMsgView : UIView
@property (nonatomic,copy) HanderMsgViewDoneBlock block;
-(instancetype)handerMsgWithFrame:(CGRect)frame finishedBlock:(HanderMsgViewDoneBlock)block;
@end
