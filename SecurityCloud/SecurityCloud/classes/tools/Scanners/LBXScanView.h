//
//  LBXScanView.h
//
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/11/15.
//  Copyright © 2015年 lbxia. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LBXScanNetAnimation.h"




/**
 扫码区域显示效果
 */
@interface LBXScanView : UIView

/**
 @brief  初始化
 @param frame 位置大小


 @return instancetype
 */
-(id)initWithFrame:(CGRect)frame;

/**
 *  设备启动中文字提示
 */
- (void)startDeviceReadyingWithText:(NSString*)text;

/**
 *  设备启动完成
 */
- (void)stopDeviceReadying;

/**
 *  开始扫描动画
 */
- (void)startScanAnimation;

/**
 *  结束扫描动画
 */
- (void)stopScanAnimation;

//

/**
 @brief  根据矩形区域，获取Native扫码识别兴趣区域
 @param view  视频流显示UIView

 @return 识别区域
 */
+ (CGRect)getScanRectWithPreView:(UIView*)view;





@end
