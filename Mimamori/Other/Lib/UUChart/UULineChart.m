//
//  UULineChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UULineChart.h"
#import "UUColor.h"
#import "UUChartLabel.h"
#import "UUChart.h"

@implementation UULineChart {

    int deviceclassid;
//    int uiType;
    CAShapeLayer *_chartLine2;
    CAGradientLayer *gradientLayer;
    NSString *temperature;  //温度
}
-(void)backgroundColor:(NSString *)deviceclass devicename:(NSString*)devicename devicedate:(NSString*)devicedate{
    temperature = deviceclass;
    if ([deviceclass isEqualToString:@"温度"]) {
        UIColor *lightG = NITColorAlpha(255,90,75,0.7);
        UIColor *darkG = NITColorAlpha(215,51,30,1);
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
        gradient.frame = self.bounds;
        [self.layer insertSublayer:gradient atIndex:0];
    }else if([deviceclass isEqualToString:@"湿度"]){
        UIColor * lightG= NITColorAlpha(155,125,255,0.7);
        UIColor *darkG = NITColorAlpha(115,65,255,1);
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
        gradient.frame = self.bounds;
        [self.layer insertSublayer:gradient atIndex:0];
        
    }else if([deviceclass isEqualToString:@"明るさ"]){
        UIColor * lightG= NITColorAlpha(235,235,0,0.7);
        UIColor *darkG = NITColorAlpha(205,165,0,1);
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
        gradient.frame = self.bounds;
        [self.layer insertSublayer:gradient atIndex:0];
    }else {
        UIColor *lightG = NITColorAlpha(115,180,255,1);
        UIColor *darkG = NITColorAlpha(85,160,225,1);
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
        gradient.frame = self.bounds;
        [self.layer insertSublayer:gradient atIndex:0];
    }
  
    UILabel*typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width*0.8, self.frame.size.height)];
    typeLabel.center = self.center;
    typeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:55];
    typeLabel.alpha = 0.2;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.text = devicename;
    typeLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:typeLabel];
    
    UILabel*dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width*0.5, 0, self.width * 0.5, 20)];
    dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    dateLabel.alpha = 0.8;
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.text = devicedate;
    dateLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:dateLabel];
    
//    UIView*pathLabelTwo = [[UIView alloc]initWithFrame:CGRectMake(0,self.bounds.size.height-10, [UIScreen mainScreen].bounds.size.width,0.5)];
//    pathLabelTwo.backgroundColor = [UIColor whiteColor];
//    [self addSubview:pathLabelTwo];
//    
//    UIView*pathLabelOne = [[UIView alloc]initWithFrame:CGRectMake(0,10, [UIScreen mainScreen].bounds.size.width,0.5)];
//    pathLabelOne.backgroundColor = [UIColor whiteColor];
//    [self addSubview:pathLabelOne];
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 6;
        self.opaque = YES;
        
    }
    
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    
}
-(void)setYValuesTwo:(NSArray *)yValues2
{
    [self setYLabels:yValues2];
}

-(void)setYLabels:(NSArray *)yLabels
{
//    NSInteger maxV = [[[yLabels objectAtIndex:0] objectAtIndex:0] integerValue];
//    NSInteger minV = [[[yLabels objectAtIndex:0] objectAtIndex:1] integerValue];
//    if ([temperature isEqualToString:@"温度"]) {
//        
//        _yValueMax = maxV;
//        _yValueMin = minV;
//    } else if ([temperature isEqualToString:@"湿度"]) {
//        _yValueMax = maxV;
//        _yValueMin = minV;
//        
//    } else if ([temperature isEqualToString:@"明るさ"]) {
//        _yValueMax = maxV;
//        _yValueMin = minV;
//    } else {
        float max = 0;
        float min = 1000000000;
        
        for (NSArray * ary in yLabels) {
            for (NSNumber *valueString in ary) {
                float value;
                //            if ([uidd isEqualToString:@"8"]&&(uiType == 0 || uiType == 4)) {
                //                value = 50;
                //            }else if([uidd isEqualToString:@"8"]&&(uiType == 1 || uiType == 5)){
                //                value = 100;
                //            }else if([uidd isEqualToString:@"8"]&&(uiType == 2 || uiType == 6)){
                //                value = 100;
                if(deviceclassid==1){
                    
                    value = 100;
                    
                } else {
                    
                    float tmpValue = [valueString floatValue];
                    value = tmpValue;
                    
                }
                
                if (value > max) {
                    max = value;
                }
                if (value < min) {
                    min = value;
                }
            }
        }
        
//        if (self.showRange) {
            _yValueMin = (int)min;
//        }
//        else{
//            _yValueMin = 0;
//        }
    
        int Ma = ceilf(max * 1.0);
        _yValueMax = Ma;
        
        if (_chooseRange.max!=_chooseRange.min) {
            _yValueMax = _chooseRange.max;
            _yValueMin = _chooseRange.min;
        }
//    }
    float level = (_yValueMax-_yValueMin) /4.0;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /4.0;
    
    for (int i=0; i<5; i++) {
        
        if (i<1||i>3) {
            
            if (_yValueMax >0) {
                
                UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth*1.1, UULabelHeight)];
                label.text = [NSString stringWithFormat:@"%d",(int)(level * i+_yValueMin)];
                [self addSubview:label];
                
            }
            
        }else{
            
            if(deviceclassid==1){
                
                UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth*1.1, UULabelHeight)];
                label.text = [NSString stringWithFormat:@"%d",(int)(level * i+_yValueMin)];
                [self addSubview:label];
                
            }
            
        }
    }
    
    
}

-(void)setXLabels:(NSArray *)xLabels
{
    
    _xLabels = xLabels;
    CGFloat num = 0;
    
    num = xLabels.count;
    
    _xLabelWidth = (self.frame.size.width-5 - UUYLabelwidth)/num;
    
    for (int i=0; i<xLabels.count; i++) {
        
        NSString *labelText = xLabels[i];
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+UUYLabelwidth, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        
        label.text = labelText;
        if (xLabels.count>40) {
            if ([label.text intValue]%2!=0) {
                label.text = [NSString stringWithFormat:@"%d",[label.text intValue]/2];
                label.frame =  CGRectMake(i * _xLabelWidth+UUYLabelwidth-1.5, self.frame.size.height - UULabelHeight, _xLabelWidth*1.5, UULabelHeight);
            }else{
               label.text = @"";
            }
        }
        if (xLabels.count >25&&xLabels.count<40) {
            if ([label.text intValue] >1 && [label.text intValue] <7) {
                label.text = @"";
            }else if([label.text intValue] >7 && [label.text intValue] <13){
                label.text = @"";
            }else if([label.text intValue] >13 && [label.text intValue] <19){
                label.text = @"";
            }else if([label.text intValue] >19 && [label.text intValue] <25){
                label.text = @"";
            }else if([label.text intValue] >25 && [label.text intValue] <xLabels.count){
                label.text = @"";
            }
        }
        //        if (xLabels.count <8) {
        //            if ([label.text isEqualToString: @"0"]) {
        //                label.text = @"月";
        //            }else if([label.text isEqualToString: @"1"]){
        //                label.text = @"火";
        //            }else if([label.text isEqualToString: @"2"]){
        //                label.text = @"水";
        //            }else if([label.text isEqualToString: @"3"]){
        //                label.text = @"木";
        //            }else if([label.text isEqualToString: @"4"]){
        //                label.text = @"金";
        //            }else if([label.text isEqualToString: @"5"]){
        //                label.text = @"土";
        //            }else if([label.text isEqualToString: @"6"]){
        //                label.text = @"日";
        //            }
        //        }
        [self addSubview:label];
    }
    
}

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
}

- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}

-(void)strokeCharttwo
{
    [_chartLine2 removeFromSuperlayer];
    [gradientLayer removeFromSuperlayer];
    
    for (int i=0; i<_yValues.count; i++) {
        
        NSArray *childAry = _yValues[i];
        

        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/2.0);
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
        
        //第一个点
        [progressline moveToPoint:CGPointMake(xPosition,self.frame.size.height-6)];
        [progressline addLineToPoint:CGPointMake(xPosition,self.frame.size.height-6)];
        
        NSInteger index = 0;
        
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (isnan(grade)) {
                grade = 0;
            }
            CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
            [progressline addLineToPoint:point];
            
            index += 1;
            
        }
        
        [progressline addLineToPoint:CGPointMake(xPosition+(childAry.count-1)*_xLabelWidth,self.frame.size.height-6)];
        [progressline closePath];
        //dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //划线
        _chartLine2 = [CAShapeLayer layer];
        _chartLine2.opaque = YES;
        _chartLine2.fillColor = [UIColor whiteColor].CGColor;
        _chartLine2.lineWidth   = 1.0;
        _chartLine2.path = progressline.CGPath;
       

    }
    
    
    
}
-(void)strokeChart
{
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i = 0;
        NSInteger min_i = 0;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor blackColor] CGColor];
        _chartLine.lineWidth   = 0.7;
        _chartLine.lineDashPhase=6.0;
        _chartLine.strokeEnd   = 0.0;
        _chartLine.opaque = YES;
        _chartLine.drawsAsynchronously = YES;

        [self.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/2.0);
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        
        if (isnan(grade)) {
            grade = 0;
        }
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.ShowMaxMinArray) {
            if ([self.ShowMaxMinArray[i] intValue]>0) {
                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
            }else{
                isShowMaxAndMinPoint = YES;
            }
        }
        
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (isnan(grade)) {
                grade = 0;
            }
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                if (self.ShowMaxMinArray) {
                    if ([self.ShowMaxMinArray[i] intValue]>0) {
                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                    }else{
                        isShowMaxAndMinPoint = YES;
                    }
                }
                [progressline moveToPoint:point];
                
            }
            index += 1;
        }
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [UUWhite CGColor];
        }
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*0.06;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
    }
    
}
-(id)init{
    
    
    return self;
}
//- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
//{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 6, 6)];
//    view.center = point;
//    view.layer.drawsAsynchronously = YES;
//    view.layer.masksToBounds = YES;
//    view.layer.cornerRadius = 3;
//    view.clipsToBounds = YES;
//    view.layer.borderWidth = 1.2;
//    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:UUWhite.CGColor;
//    view.opaque = YES;
//    if (isHollow) {
//        //圆点心颜色
//        if ([uidd isEqualToString:@"8"]) {
//            if (uiType == 0 || uiType == 4) {
//                view.backgroundColor =  [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0f];
//            }else if(uiType == 1 || uiType == 5){
//                view.backgroundColor =  [UIColor colorWithRed:0.0/255.0 green:130.0/255.0 blue:258.0/255.0 alpha:1.0f];
//            }else{
//                view.backgroundColor =  [UIColor colorWithRed:255.0/255.0 green:184.0/255.0 blue:0.0/255.0 alpha:1.0f];
//            }
//        }else{
//            view.backgroundColor =  [UIColor colorWithRed:64.0/255.0 green:224.0/255.0 blue:208.0/255.0 alpha:1.0f];
//        }
//    }else{
//        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:UUGreen;
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
//        label.font = [UIFont systemFontOfSize:10];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = view.backgroundColor;
//        label.text = [NSString stringWithFormat:@"%d",(int)value];
//        [self addSubview:label];
//    }
//    
//    [self addSubview:view];
//}


@end
