//
//  UULineChart.h
//  UUChartDemo
//
//  Created by NISSAY IT.
//  Copyright (c) 2014年 NISSAY IT.
//


#import <UIKit/UIKit.h>
#import "UUColor.h"

#define chartMargin     10
#define xLabelMargin    15
#define yLabelMargin    15
#define UULabelHeight    10
#define UUYLabelwidth     20
#define UUTagLabelwidth     80

@interface UULineChart : UIView

-(void)backgroundColor:(NSString *)deviceclass devicename:(NSString*)devicename devicedate:(NSString*)devicedate;

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;

-(void)setYValuesTwo:(NSArray *)yValues2;

@property (nonatomic, strong) NSArray * colors;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;

@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;

@property (nonatomic, retain) NSMutableArray *ShowHorizonLine;
@property (nonatomic, retain) NSMutableArray *ShowMaxMinArray;

-(void)strokeChart;
-(void)strokeCharttwo;
//- (NSArray *)chartLabelsForX;

@end
