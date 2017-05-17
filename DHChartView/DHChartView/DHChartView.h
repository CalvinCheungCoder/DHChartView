//
//  DHChartView.h
//  DHChartView
//
//  Created by 张丁豪 on 2017/5/16.
//  Copyright © 2017年 zhangdinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHChartView : UIView

/**
 X轴坐标的title
 */
@property (nonatomic, strong) NSArray *dataArrOfX;
/**
 图表的数据
 */
@property (nonatomic, strong) NSArray *leftDataArr;
/**
 图表连线的颜色
 */
@property (nonatomic, strong) UIColor *lineColor;
/**
 顶部遮罩颜色,设置 alpha
 */
@property (nonatomic, strong) UIColor *maskTopColor;
/**
 底部遮罩颜色,设置 alpha
 */
@property (nonatomic, strong) UIColor *maskBottomColor;
/**
 选中后的按钮颜色
 */
@property (nonatomic, strong) UIColor *btnSeleColor;
/**
 正常的按钮颜色
 */
@property (nonatomic, strong) UIColor *btnNorColor;

/**
 提示文本的颜色
 */
@property (nonatomic, strong) UIColor *tipsTextColor;

/**
 提示文本的背景颜色
 */
@property (nonatomic, strong) UIColor *tipsTextBackColor;

/**
 提示文本的边框颜色
 */
@property (nonatomic, strong) UIColor *tipsTextLayerColor;

/**
 x轴标题颜色
 */
@property (nonatomic, strong) UIColor *xLabelColor;

@end
