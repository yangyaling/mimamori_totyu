//
//  UUBarChart.h
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUColor.h"

#define chartMargin     10
#define xLabelMargin    15
#define yLabelMargin    15
#define UULabelHeight   10
#define UUYLabelwidth   20

@interface UUBarChart : UIView

/**
 * This method will call and troke the line in animation
 */

-(void)strokeChart;

-(void)barbackgroundColor:(NSString *)deviceclass devicename:(NSString*)devicename devicedate:(NSString*)devicedate;

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;

@property (strong, nonatomic) NSArray * yValues2;

-(void)setYValuesTwo:(NSArray *)yValues2;

@property (nonatomic) CGFloat xLabelWidth;

@property (nonatomic) float yValueMax;
@property (nonatomic) float yValueMin;

@property (nonatomic, assign) BOOL showRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, strong) NSArray * colors;

//- (NSArray *)chartLabelsForX;

@end
