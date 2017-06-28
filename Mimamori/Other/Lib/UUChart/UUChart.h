//
//  UUChart.h
//	Version 0.1
//  UUChart
//
//  Created by NISSAY IT.
//  Copyright (c) 2014年 NISSAY IT.
//

#import <UIKit/UIKit.h>
#import "UUChart.h"
#import "UUColor.h"
#import "UULineChart.h"
#import "UUBarChart.h"
//
typedef enum {
	UUChartLineStyle,
	UUChartBarStyle
} UUChartStyle;


@class UUChart;
@protocol UUChartDataSource <NSObject>

@required



//
- (NSArray *)UUChart_xLableArray:(UUChart *)chart;

//
- (NSArray *)UUChart_yValueArray:(UUChart *)chart;

- (NSArray *)UUChart_yValueArray4:(UUChart *)chart;

@optional

- (NSArray *)UUChart_ColorArray:(UUChart *)chart;


- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart;

#pragma mark 折线图专享功能

- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart;

- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;


- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index;
@end

@interface UUChart : UIView


@property (nonatomic, assign) BOOL showRange;

@property (assign) UUChartStyle chartStyle;

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource>)dataSource withStyle:(UUChartStyle)style withdevicename:(NSString *)devicename withname:(NSString*)uuname withdate:(NSString*)date;

- (void)showInView:(UIView *)view;

-(void)strokeChart;
-(void)setUpChart;

@end
