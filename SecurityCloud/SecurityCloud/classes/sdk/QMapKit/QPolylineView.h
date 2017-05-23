/*
 ============================================================================
 Name           : QPolylineView.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QPolylineView declaration
 ============================================================================
 */

/**    @file QPolylineView.h     */

#import "QOverlayPathView.h"
#import "QPolyline.h"

/*!
 *  @brief   此类是QPolyline用于显示多段线的view,可以通过QOverlayPathView修改其fill和stroke属性来配置样式
 */
@interface QPolylineView : QOverlayPathView

/*!
 *  @brief  根据指定的QPolyline生成一个多段线view
 *
 *  @param polyline 指定的QPolyline
 *
 *  @return 新生成的折线段view
 */
- (id)initWithPolyline:(QPolyline *)polyline;

/*!
 *  @brief  关联的QPolyline对象
 */
@property (nonatomic, readonly) QPolyline *polyline;
/**
 *  @brief  边线的颜色
 */
@property (nonatomic, strong)   UIColor*    edgeColor;
/**
 *  @brief  边界线的宽度
 */
@property (nonatomic, assign)   CGFloat     edgeLineWidth;

/**
 *  @brief 设定箭头的间距, 单位为图片宽度的倍数, 默认为5
 */
@property (nonatomic, assign)   CGFloat     symbolGap;
/**
 *  设置箭头的图片, 请为不同图片各自传入代表性的标识串.(图片大小请为2的整次幂)
 */
- (void)setSymbolImage:(UIImage *)symbolImage andIdentifier:(NSString*)key;
/**
 * 获取设置的箭头图片
 */
- (NSDictionary*)symbolImage;


@end
