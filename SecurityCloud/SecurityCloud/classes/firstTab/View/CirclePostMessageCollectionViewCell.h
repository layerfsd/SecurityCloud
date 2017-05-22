//
//  CirclePostMessageCollectionViewCell.h
//  TodaySoft
//
//  Created by hsgene_xu on 2017/3/9.
//  Copyright © 2017年 haoyee. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CirclePostMessageCollectionViewCellDelegate <NSObject>
-(void)cancelImage: (NSInteger)item;
@end


@interface CirclePostMessageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *x_contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *x_deleteButton;

@property (assign, nonatomic) id<CirclePostMessageCollectionViewCellDelegate> delegate;

@end
