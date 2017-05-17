//
//  ViewController.m
//  DHChartView
//
//  Created by 张丁豪 on 2017/5/16.
//  Copyright © 2017年 zhangdinghao. All rights reserved.
//

#import "ViewController.h"
#import "DHChartView.h"

@interface ViewController ()

@property (nonatomic, strong) DHChartView *ChartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *tempDataArrOfY = @[@"3556",@"4526",@"5277",@"6829",@"5902"];
    _ChartView = [[DHChartView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 160)];
    _ChartView.backgroundColor = [UIColor clearColor];
//    _ChartView.lineColor = [UIColor redColor];
//    _ChartView.maskTopColor = [UIColor colorWithRed:81/255.0 green:183/25.0 blue:200/255.0 alpha:0.6];
//    _ChartView.maskBottomColor = [UIColor colorWithRed:81/255.0 green:183/25.0 blue:200/255.0 alpha:0.2];
    _ChartView.leftDataArr = tempDataArrOfY;
    _ChartView.dataArrOfX = @[@"一月",@"二月",@"三月",@"四月",@"五月"];//拿到X轴坐标
    [self.view addSubview:_ChartView];
}


@end
