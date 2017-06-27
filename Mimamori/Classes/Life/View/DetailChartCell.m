//
//  DetailChartCell.m
//  Mimamori
//
//  Created by NISSAY IT on 16/9/26.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "DetailChartCell.h"
#import "ZworksChartModel.h"

#import "UUChart.h"

#define NITUUChartHeight 156

#define NITUUChartBorder 3

@interface DetailChartCell ()<UUChartDataSource>


@property (nonatomic, strong) UUChart                        *chartView;


@property (nonatomic, strong) NSArray                        *devicedataarray;  //


@property (nonatomic, strong) NSMutableArray                 *allarray;  //グラフデータ


@end

@implementation DetailChartCell


/**
 登録セル
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    DetailChartCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChartCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DetailChartCell" owner:self options:nil].firstObject;
    }
    
    return cell;
}

/**
 整理のデータをグラフにする
 */
-(void)setChartdic:(NSDictionary *)chartdic{
    _allarray = [NSMutableArray array];
    
    NSArray *devicearray = chartdic[@"devicevalues"];
    
    
    NSString *sensorname = [NSString stringWithFormat:@"%@:%.2f%@",chartdic[@"devicename"],[chartdic[@"latestvalue"] floatValue],chartdic[@"deviceunit"]];
    
    
    _devicedataarray = [NSArray arrayWithArray:devicearray];
    
    [_allarray addObject:_devicedataarray];
    
    
    //初期設定チャート
    _chartView =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(3,5.5, [UIScreen mainScreen].bounds.size.width-6, 150)
                                              withSource:self withStyle:UUChartLineStyle withdevicename:chartdic[@"devicename"] withname:sensorname withdate:_dateStr];
    _chartView.userInteractionEnabled = NO;
    
    [_chartView showInView:self.contentView];
    
}



-(NSArray*)getXTitles:(int)num{
    NSMutableArray *xTitles = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i =0; i<=num; i++) {
        if(num<25&&num>11){
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [xTitles addObject:str];
        }else{
            NSString *str = [NSString stringWithFormat:@"%d",i+1];
            [xTitles addObject:str];
        }
    }
    return xTitles;
}

/**
 x座標分類
 */
- (NSArray *)UUChart_xLableArray:(UUChart *)chart{
    
    return [self getXTitles:47];
}

/**
 y座標分類
 */
- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
    
    return @[self.devicedataarray];
    
}


- (NSArray *)UUChart_yValueArray4:(UUChart *)chart{

    return self.allarray;
    
}

/**
 グラフの色
 */
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUWhite];
}



@end
