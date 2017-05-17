//
//  DHChartView.m
//  DHChartView
//
//  Created by 张丁豪 on 2017/5/16.
//  Copyright © 2017年 zhangdinghao. All rights reserved.
//

#import "DHChartView.h"
#import "UIButton+EnlargeTouchArea.h"
#import "UIColor+FlatColors.h"
#import "UIView+Common.h"

#define btnW 8

@interface DHChartView ()
{
    CGFloat Xmargin;//X轴方向的偏移
    CGFloat Ymargin;//Y轴方向的偏移
    CGPoint lastPoint;//最后一个坐标点
    UIButton *firstBtn;
    UIButton *lastBtn;
}

@property (nonatomic, strong) UIView *chartView;
@property (nonatomic, strong) UIView *bgView1;// 背景图
@property (nonatomic, strong) UIView *scrollBgView1; // 表格背景
@property (nonatomic, strong) NSMutableArray *leftPointArr;// 左边的数据源
@property (nonatomic, strong) NSMutableArray *leftBtnArr;// 左边按钮
@property (nonatomic, strong) NSMutableArray *detailLabelArr;

@end

@implementation DHChartView

- (UIColor *)lineColor
{
    if (!_lineColor) {
        _lineColor = [UIColor colorWithRed:96/255.0 green:205/25.0 blue:255/255.0 alpha:1];
    }
    return _lineColor;
}

-(UIColor *)maskTopColor
{
    if (!_maskTopColor) {
        _maskTopColor = [UIColor colorWithRed:96/255.0 green:205/25.0 blue:255/255.0 alpha:0.6];
    }
    return _maskTopColor;
}

-(UIColor *)maskBottomColor
{
    if (!_maskBottomColor) {
        _maskBottomColor = [UIColor colorWithRed:96/255.0 green:205/25.0 blue:255/255.0 alpha:0.1];
    }
    return _maskBottomColor;
}

-(UIColor *)btnNorColor
{
    if (!_btnNorColor) {
        _btnNorColor = [UIColor redColor];
    }
    return _btnNorColor;
}

-(UIColor *)btnSeleColor
{
    if (!_btnSeleColor) {
        _btnSeleColor = [UIColor greenColor];
    }
    return _btnSeleColor;
}

-(UIColor *)tipsTextColor
{
    if (!_tipsTextColor) {
        _tipsTextColor = [UIColor redColor];
    }
    return _tipsTextColor;
}

-(UIColor *)tipsTextBackColor
{
    if (!_tipsTextBackColor) {
        _tipsTextBackColor = [UIColor colorWithRed:254/255.0 green:247/255.0 blue:237/255.0 alpha:1.0];
    }
    return _tipsTextBackColor;
}

-(UIColor *)tipsTextLayerColor
{
    if (!_tipsTextLayerColor) {
        _tipsTextLayerColor = [UIColor redColor];
    }
    return _tipsTextLayerColor;
}

#pragma mark --
#pragma mark -- 表格背景
-(UIView *)scrollBgView1{
    if (!_scrollBgView1) {
        _scrollBgView1 = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.chartView.bounds.size.width-30, self.chartView.bounds.size.height)];
    }
    return _scrollBgView1;
}

#pragma mark --
#pragma mark -- 背景网格
-(UIView *)bgView1{
    if (!_bgView1) {
        _bgView1 = [[UIView alloc]initWithFrame:CGRectMake(5, 0, self.scrollBgView1.bounds.size.width-10, self.scrollBgView1.bounds.size.height-20)];
        _bgView1.layer.masksToBounds = YES;
        _bgView1.layer.borderWidth = 1;
        _bgView1.layer.borderColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1].CGColor;
    }
    return _bgView1;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.leftPointArr = [NSMutableArray array];
        self.leftBtnArr = [NSMutableArray array];
        self.detailLabelArr = [NSMutableArray array];
        [self addDetailViews];
    }
    return self;
}

#pragma mark --
#pragma mark -- 数据源
-(void)setDataArrOfX:(NSArray *)dataArrOfX{
    
    _dataArrOfX = dataArrOfX;
    [self addLines1With:self.bgView1];
    [self addDataPointWith:self.scrollBgView1 andArr:_leftDataArr];//添加点
    [self addLeftBezierPoint];// 添加连线
    [self addBottomViewsWith:self.scrollBgView1];
}

-(void)setLeftDataArr:(NSArray *)leftDataArr{
    
    _leftDataArr = leftDataArr;
}


#pragma mark --
#pragma mark -- 背景
-(void)addDetailViews{
    
    self.chartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.chartView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.chartView];
    
    [self.chartView addSubview:self.scrollBgView1];
    [self.scrollBgView1 addSubview:self.bgView1];
}

#pragma mark --
#pragma mark -- 添加数据曲线
-(void)addLeftBezierPoint{
    
    // 取得起始点
    CGPoint p1 = [[self.leftPointArr objectAtIndex:1] CGPointValue];
    NSLog(@"%f %f",p1.x,p1.y);
    // 直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    // 遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    
    for (int i = 0;i<self.leftPointArr.count;i++ ) {
        if (i != 0) {
            
            CGPoint prePoint = [[self.leftPointArr objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[self.leftPointArr objectAtIndex:i] CGPointValue];
            
            [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            if (i == self.leftPointArr.count-1) {
                [beizer moveToPoint:nowPoint];//添加连线
                lastPoint = nowPoint;
            }
        }
    }
    
    CGFloat bgViewHeight = self.bgView1.bounds.size.height;
    // 获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    
    // 最后一个点对应的X轴的值
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    
    [bezier1 addLineToPoint:lastPointX1];
    
    // 回到原点
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    [bezier1 addLineToPoint:p1];
    
    // 遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    // 渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, self.scrollBgView1.bounds.size.height-50);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)self.maskTopColor.CGColor,(__bridge id)self.maskBottomColor.CGColor];
    gradientLayer.locations = @[@(0.5f)];
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    
    [self.scrollBgView1.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 1.6f;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(15, 0, 2*lastPoint.x, self.scrollBgView1.bounds.size.height-60)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
    // 添加动画连线
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = self.lineColor.CGColor;
    shapeLayer.lineWidth = 2;
    [self.scrollBgView1.layer addSublayer:shapeLayer];
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration = 1.6f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    for (UIButton *btn in self.leftBtnArr) {
        [self.scrollBgView1 addSubview:btn];
    }
}


#pragma mark --
#pragma mark -- 画按钮和点击后的 Label
-(void)addDataPointWith:(UIView *)view andArr:(NSArray *)leftData{
    
    CGFloat height = self.bgView1.bounds.size.height;
    // 初始点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:leftData];
    [arr insertObject:arr[0] atIndex:0];
    
    float tempMax = [arr[0] floatValue];
    
    for (int i = 1; i < arr.count; ++i) {
        if ([arr[i] floatValue] > tempMax) {
            tempMax = [arr[i] floatValue];
        }
    }
    
    for (int i = 0; i<arr.count; i++) {
        
        float tempHeight = [arr[i] floatValue] * 0.8 / tempMax ;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((Xmargin)*(i-1), height *(1 - tempHeight) - btnW/2 , btnW, btnW)];
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = btnW/2;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        if (i == 0) {
            firstBtn = btn;
            btn.hidden = YES;
        }else if ( i == arr.count - 1){
            
            lastBtn = btn;
            btn.selected = YES;
        }
        if (btn.selected == YES) {
            btn.backgroundColor = self.btnSeleColor;
        }else{
            btn.backgroundColor = self.btnNorColor;
        }
//        [btn setBackgroundImage:[UIImage imageNamed:@"img_wdzc_zcfx_sye_ellipse"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"img_wdzc_zcfx_sye_ellipse_hollow"] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(TopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        
        [self.leftBtnArr addObject:btn];
        
        NSValue *point = [NSValue valueWithCGPoint:btn.center];
        [self.leftPointArr addObject:point];
        
        /** 创建Label */
        UILabel * detailLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.scrollBgView1 addSubview: detailLabel];
        detailLabel.textColor = self.tipsTextColor;
        detailLabel.tag = 200 + i;
        detailLabel.numberOfLines = 0;
        detailLabel.font = [UIFont systemFontOfSize:12.0f];
        NSString *str = arr[i];
        CGSize textSize = [str boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil].size;;
        [detailLabel setFrame:CGRectMake((Xmargin)*(i-1)-textSize.width/2+btnW/2, height *(1 - tempHeight)-30, textSize.width, textSize.height)];
        detailLabel.text = str;
        detailLabel.textAlignment = NSTextAlignmentCenter;
        [detailLabel setBackgroundColor:self.tipsTextBackColor];
        [detailLabel setLayerWidth:0.6f layerColor:self.tipsTextLayerColor radius:2.0f];
        if (i == arr.count - 1) {
            detailLabel.hidden = NO;
        }else{
            detailLabel.hidden = YES;
        }
        [self.detailLabelArr addObject:detailLabel];
    }
}

#pragma mark --
#pragma mark -- x轴标题
-(void)addBottomViewsWith:(UIView *)UIView{
    
    NSArray *bottomArr;
    if (UIView == self.scrollBgView1) {
        bottomArr = _dataArrOfX;
    }
    for (int i = 0;i < bottomArr.count ;i++ ) {
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(+i*Xmargin-Xmargin/2+5, 6*Ymargin, Xmargin, 20)];
        leftLabel.font = [UIFont systemFontOfSize:10.0f];
        leftLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        leftLabel.text = bottomArr[i];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        [UIView addSubview:leftLabel];
    }
}

-(void)TopBtnAction:(UIButton *)sender{
    
    for (UIButton*btn in _leftBtnArr) {
        if (sender.tag == btn.tag) {
            btn.selected = YES;
            btn.backgroundColor = self.btnSeleColor;
        }else{
            btn.selected = NO;
            btn.backgroundColor = self.btnNorColor;
        }
    }
    [self showDetailLabel:sender];
}

-(void)showDetailLabel:(UIButton *)sender{
    
    for (UILabel * label in _detailLabelArr) {
        if (sender.tag+200 == label.tag) {
            label.hidden = NO;
        }else{
            label.hidden = YES;
        }
    }
}

#pragma mark --
#pragma mark -- 画横线和竖线
-(void)addLines1With:(UIView *)view{
    
    // 横线
    CGFloat magrginHeight = (view.bounds.size.height)/ 6; // 行高
    CGFloat labelWith = view.bounds.size.width;
    Ymargin = magrginHeight;
    
    for (int i = 0;i < 5 ;i++ ) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, magrginHeight+magrginHeight*i, labelWith, 1)];
        label.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        [view addSubview:label];
    }
    
    // 竖线
    CGFloat marginWidth = view.bounds.size.width/(_leftDataArr.count-1);
    Xmargin = marginWidth;
    CGFloat labelHeight = view.bounds.size.height;
    
    for (int i = 0;i< _leftDataArr.count ;i++ ) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(marginWidth*i, 0, 1, labelHeight)];
        label.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        if (i != 0) {
            [view addSubview:label];
        }
    }
}

@end
