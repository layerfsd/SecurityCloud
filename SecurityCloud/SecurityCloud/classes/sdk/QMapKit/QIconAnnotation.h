//
//  QIconAnnotation.h
//  QMapKit
//
//  Created by fan on 2016/11/25.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QAnnotation.h"

@interface QIconAnnotation : NSObject <QAnnotation>

/**
 *  @brief icon的图片, 请为不同的图片分别设置其对应的iconId. 默认为nil
 */
@property (nonatomic, strong)   UIImage*    icon;
/**
 *  @brief icon的标识串, 请为不同的图片分别设置其对应的值. 默认为nil
 */
@property (nonatomic, strong)   NSString*   iconId;
/**
 *  @brief 锚点. 左上为{0,0}, 默认为{0.5，1}
 */
@property (nonatomic, assign)   CGPoint     anchorPoint;

/**
 *  @brief 图片的角度. 逆时针方向, 单位:degree
 */
@property (nonatomic, assign)   CGFloat     angle;

/**
 *  @brief 地理坐标
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/**
 *  @brief 构建annotation实例
 */
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coord;

@end
