//
//  UUBarChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBarChart.h"
#import "UUChartLabel.h"
#import "UUBar.h"

@interface UUBarChart ()
{
    UIView *myScrollView;
}
@end

@implementation UUBarChart {
    //NSHashTable *_chartLabelsForX;
}
-(void)barbackgroundColor:(NSString *)deviceclass devicename:(NSString*)devicename devicedate:(NSString*)devicedate{
//    if (deviceclass==1) {

//        if (utype == 0 || utype == 4) {
//            UIColor *lightG = NITColorAlpha(255,90,75,0.7);
//            UIColor *darkG = NITColorAlpha(215,51,30,1);
//            CAGradientLayer *gradient = [CAGradientLayer layer];
//            gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
//            gradient.frame = self.bounds;
//            [self.layer insertSublayer:gradient atIndex:0];
//        }else if(utype == 1 || utype == 5){
//            UIColor * lightG= NITColorAlpha(155,125,255,0.7);
//            UIColor *darkG = NITColorAlpha(115,65,255,1);
//            CAGradientLayer *gradient = [CAGradientLayer layer];
//            gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
//            gradient.frame = self.bounds;
//            [self.layer insertSublayer:gradient atIndex:0];
//        }else if(utype == 2 || utype == 6){
//            UIColor * lightG= NITColorAlpha(235,235,0,0.7);
//            UIColor *darkG = NITColorAlpha(205,165,0,1);
//            CAGradientLayer *gradient = [CAGradientLayer layer];
//            gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
//            gradient.frame = self.bounds;
//            [self.layer insertSublayer:gradient atIndex:0];
//        }else if(utype == 3 || utype == 7){
//        }
        
//    }else{
        UIColor *lightG = NITColorAlpha(115,180,255,1);
        UIColor *darkG = NITColorAlpha(85,160,225,1);
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.colors = [NSArray arrayWithObjects:(id)lightG.CGColor,(id)darkG.CGColor, nil];
        gradient.frame = self.bounds;
        [self.layer insertSublayer:gradient atIndex:0];
//    }
    UILabel*typeLabel = [[UILabel alloc]initWithFrame:self.frame];
    typeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:55];
    typeLabel.alpha = 0.2;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.text = devicename;
    typeLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:typeLabel];
    
    UILabel*dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.6, 0, self.frame.size.width*0.4, 20)];
    dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    dateLabel.alpha = 0.8;
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.text = devicedate;
//    dateLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:dateLabel];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, frame.size.width-UUYLabelwidth, frame.size.height)];
        self.layer.cornerRadius = 6;
        self.opaque = YES;
        [self addSubview:myScrollView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues 
{
    _yValues = yValues;

}
-(void)setYValuesTwo:(NSArray *)yValues2
{
    _yValues2 = yValues2;
    [self setYLabels:_yValues2];
}
-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;
    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }

    if (self.showRange) {
        _yValueMin = (int)min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }
    
    int num;
    
    if (_yValueMax<=10) {
        
        num = _yValueMax;
        
    }else{
        
        num = 4;
        
    }

//    float level = (_yValueMax-_yValueMin)/num;
//    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
//    CGFloat levelHeight = chartCavanHeight/num;
//
//    for (int i=0; i<=num; i++) {
//
//        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth*1.1, UULabelHeight)];
//        
//        label.text = [NSString stringWithFormat:@"%.0f",level * i+_yValueMin];
//        
//        [self addSubview:label];
//
//    }
    
    float level = (_yValueMax-_yValueMin) /4.0;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /4.0;
    
    for (int i=0; i<5; i++) {
        
        if (i<1||i>3) {
            
            if (max >0) {
            
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
    NSInteger num;

    num = xLabels.count;
    
    _xLabelWidth = (self.frame.size.width-5 - UUYLabelwidth)/num;
    
    for (int i=0; i<xLabels.count; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake((i *  _xLabelWidth ), self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = xLabels[i];
        
        if (xLabels.count >25) {
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

        if (xLabels.count <8) {
            if ([label.text isEqualToString: @"0"]) {
                label.text = @"月";
            }else if([label.text isEqualToString: @"1"]){
                label.text = @"火";
            }else if([label.text isEqualToString: @"2"]){
                label.text = @"水";
            }else if([label.text isEqualToString: @"3"]){
                label.text = @"木";
            }else if([label.text isEqualToString: @"4"]){
                label.text = @"金";
            }else if([label.text isEqualToString: @"5"]){
                label.text = @"土";
            }else if([label.text isEqualToString: @"6"]){
                label.text = @"日";
            }
        }
        
        
        [myScrollView addSubview:label];

    }

}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

-(void)strokeChart
{
    
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    
    for (int i=0; i<_yValues.count; i++) {
        if (i==2)
            return;
        NSArray *childAry = _yValues[i];
        for (int j=0; j<childAry.count; j++) {
            NSString *valueString = childAry[j];
            float value = [valueString floatValue];
            float grade = ((float)value-(float)_yValueMin) / ((float)_yValueMax-(float)_yValueMin);
            
            UUBar * bar = [[UUBar alloc] initWithFrame:CGRectMake((j+(_yValues.count==1?0.1:0.05))*_xLabelWidth +i*_xLabelWidth * 0.47, UULabelHeight, _xLabelWidth * (_yValues.count==1?0.8:0.45), chartCavanHeight)];
            bar.barColor = [_colors objectAtIndex:i];
            bar.grade = grade;
            [myScrollView addSubview:bar];
            
        }
    }
}

@end
