//
//  DHChartView.h
//  DHChartView
//
//  Created by 张丁豪 on 2017/5/16.
//  Copyright © 2017年 zhangdinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHChartView : UIView

// X轴坐标数据
@property (nonatomic, strong) NSArray *dataArrOfX;
// 数据
@property (nonatomic,strong) NSArray *leftDataArr;

@end
