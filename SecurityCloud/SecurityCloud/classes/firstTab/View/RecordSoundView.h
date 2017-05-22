//
//  RecordSoundView.h
//  SecurityCloud
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RecordSoundViewBlock)(NSString *filePath);
@interface RecordSoundView : UIView
@property (nonatomic,copy) RecordSoundViewBlock block;

-(RecordSoundView*)initWithFrame:(CGRect)frame RecordBlock:(RecordSoundViewBlock)block;
@end
