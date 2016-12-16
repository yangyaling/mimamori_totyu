//
//  DetailChartCell.m
//  Mimamori
//
//  Created by 楊亜玲 on 16/9/26.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "DetailChartCell.h"
#import "ZworksChartModel.h"

#import "UUChart.h"

#define NITUUChartHeight 156
#define NITUUChartBorder 3

@interface DetailChartCell ()<UUChartDataSource>

@property (nonatomic, strong) UUChart                        *chartView;

@property (nonatomic, strong) NSArray                        *devicedataarray; //接收数组

@property (nonatomic, strong) NSMutableArray                 *allarray; //接收数组

@end

@implementation DetailChartCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    DetailChartCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChartCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DetailChartCell" owner:self options:nil].firstObject;
    }
    
    return cell;
}

-(void)setChartModel:(ZworksChartModel *)chartModel{
    _allarray = [NSMutableArray array];
    
    if (_chartView) {
        [_chartView removeFromSuperview];
    }
    
    NSString *sensorname = [NSString stringWithFormat:@"%@:%.2f%@",chartModel.devicename,[chartModel.latestvalue floatValue],chartModel.deviceunit];
    
    NSArray *devicearray = chartModel.devicevalues;
    
    _devicedataarray = [NSArray arrayWithArray:[devicearray.firstObject objectForKey:@"devicevalues"]];
    
    [_allarray addObject:_devicedataarray];
    
    _chartView =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(3,5.5, [UIScreen mainScreen].bounds.size.width-6, 150)
                                              withSource:self withStyle:UUChartLineStyle withdevicename:chartModel.devicename withname:sensorname withdate:_dateStr];
    _chartView.userInteractionEnabled = NO;
    
    [_chartView showInView:self.contentView];
    
}


-(void)setupChartView{
    
//    if (_chartView) {
//        [_chartView removeFromSuperview];
//        _chartView =nil;
//    }
//    
//    _chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(3,5, [UIScreen mainScreen].bounds.size.width-6, 148) withSource:self withStyle:UUChartLineStyle withDeviceName:_chartModel.devicename withCategory:1 latestValue:_chartModel.latestvalue dateString:self.dateStr unitString:_chartModel.deviceunit];
//    
//    
//    [self.chartView showInView:self];
    
    
    
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

- (NSArray *)UUChart_xLableArray:(UUChart *)chart{
    
    return [self getXTitles:47];
}


- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
    
    return @[self.devicedataarray];
    
}

- (NSArray *)UUChart_yValueArray4:(UUChart *)chart{

    return @[self.allarray];
    
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUWhite];
}



@end
