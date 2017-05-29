//
//  DraftBoxTableViewCell.h
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/25.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Info;
@protocol DeleteCellDelegate <NSObject>

-(void)deleteCell:(NSInteger)index;

@end
@interface DraftBoxTableViewCell : UITableViewCell
@property (nonatomic,strong) Info *model;
@property (nonatomic,weak) id<DeleteCellDelegate> delegate;
@end
