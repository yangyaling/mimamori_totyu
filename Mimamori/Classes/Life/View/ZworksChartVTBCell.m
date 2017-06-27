//
//  ZworksChartVTBCell.m
//  見守る側
//
//  Created by NISSAY IT on 16/9/13.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "ZworksChartVTBCell.h"
#import "UUChart.h"

@interface ZworksChartVTBCell()<UUChartDataSource>
{
    NSArray *devicedataarray;
    NSMutableArray *allarray;
    NSString *selectdate;
    UUChart *chartview;
}



@end
@implementation ZworksChartVTBCell



/**
 登録セル

 */
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    ZworksChartVTBCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ZworksTBCell"];
    
    return cell;
}



/**
 整理のデータをグラフにする
 */
-(void)setCellarr:(NSArray *)cellarr {
    
    _cellarr = cellarr;
    
    
    if(cellarr == nil ) return;
    
    int celltype;
    
    if (chartview) {
        [chartview removeFromSuperview];
    }
    
    
    
    selectdate = nil;
    devicedataarray = nil;
    allarray = [NSMutableArray new];
    
    NSDictionary *celldic = cellarr.firstObject;
    
    //日のグラフデータ
    if (_xnum == 0) {
        celltype=0;
        NSArray *devicevalues = [celldic objectForKey:@"devicevalues"];
        devicedataarray = devicevalues.copy;
        selectdate = self.datestr;
        [allarray addObject:devicedataarray];
        
    } else if (_xnum == 1) { //週のグラフデータ
        celltype=1;
        selectdate = self.labelstr;
        NSArray *devicevalues = [celldic objectForKey:@"devicevalues"];
        devicedataarray = devicevalues.copy;
        allarray = [NSMutableArray arrayWithArray:devicedataarray];
        
    } else { //月のグラフデータ
        celltype=2;
        selectdate = self.labelstr;
        NSArray *devicevalues = [celldic objectForKey:@"deviceinfo"];
        devicedataarray = devicevalues.copy;
        [allarray addObject:devicedataarray];
    }
    
    //初期設定チャート
    chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(6,0, [UIScreen mainScreen].bounds.size.width-12, 148)
                                             withSource:self withStyle:celltype==1?UUChartLineStyle:UUChartBarStyle withdevicename:celldic[@"devicename"] withname:celldic[@"devicename"] withdate:selectdate];
    chartview.userInteractionEnabled = NO;  //
    [chartview showInView:self.contentView];
}


/**
 x座標
 */
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
    
    switch (_xnum) {
        case 0:
            return [self getXTitles:23];
        case 1:
            return [self getXTitles:23];
        case 2:
            return [self getXTitles:[@"30" intValue]-1];
        default:
            break;
    }
    return [self getXTitles:23];
}


/**
 y座標分類
 */
- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
    
    switch (_xnum) {
        case 0:
            return @[devicedataarray];
        case 1:
            return devicedataarray;
        case 2:
            return @[devicedataarray];
        default:
            break;
    }
    return nil;
    
}

- (NSArray *)UUChart_yValueArray4:(UUChart *)chart{
    
    switch (_xnum) {
        case 0:
            return allarray;
        case 1:
            return allarray;
        case 2:
            return allarray;
        default:
            break;
    }
    return allarray;
}


/**
 グラフの色
 */
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUWhite,UUWhite,UUWhite,UUWhite,UUWhite,UUBlue,UURed];
}
@end
