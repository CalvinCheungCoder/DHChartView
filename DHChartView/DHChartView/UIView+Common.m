//
//  UIView+Common.m
//  DHChartView
//
//  Created by 张丁豪 on 2017/5/16.
//  Copyright © 2017年 zhangdinghao. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)

- (void)setLayerWidth:(CGFloat)width layerColor:(UIColor *)layerColor radius:(CGFloat)radius {
    self.clipsToBounds = YES;
    self.layer.borderWidth = MAX(width, 0);
    self.layer.borderColor = (layerColor ?: [UIColor whiteColor]).CGColor;
    self.layer.cornerRadius = MAX(radius, 0);
}

@end
