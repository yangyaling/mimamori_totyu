//
//  ZworksChartVTBCell.m
//  見守る側
//
//  Created by totyu3 on 16/9/13.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "ZworksChartVTBCell.h"
#import "UUChart.h"

@interface ZworksChartVTBCell()<UUChartDataSource>
{
    NSArray *devicedataarray;
    NSMutableArray *allarray;
    NSString *selectdata;
    UUChart *chartview;
}

//@property (nonatomic, strong) NSMutableArray                    *yNumbers;
//
//@property (strong ,nonatomic)NSMutableArray                     *mouthnumArr;

@end
@implementation ZworksChartVTBCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    ZworksChartVTBCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ZworksTBCell"];
    
//    if (!cell) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"ZworksTBCell" owner:self options:nil].firstObject;
//    }
    
    return cell;
}

-(void)setCellModel:(ZworksChartModel *)CellModel{
    _CellModel = CellModel;
    
//    NSMutableArray *tmparr = [NSMutableArray array];
//    self.yNumbers = [NSMutableArray array];
//    for (NSArray *arr in CellModel.devicevalues) {
//        NSArray *ccnumber = [arr.firstObject objectForKey:@"devicevalues"];
//        CGFloat maxValue = [[ccnumber valueForKeyPath:@"@max.floatValue"] floatValue];
//        CGFloat minValue = [[ccnumber valueForKeyPath:@"@min.floatValue"] floatValue];
//        [tmparr addObject:@((int)maxValue)];
//        [tmparr addObject:@((int)minValue)];
//    }
//    
//    CGFloat maxValue = [[tmparr valueForKeyPath:@"@max.floatValue"] floatValue];
//    CGFloat minValue = [[tmparr valueForKeyPath:@"@min.floatValue"] floatValue];
//    [self.yNumbers addObject:@((int)maxValue)];
//    [self.yNumbers addObject:@((int)minValue)];
    
    
    int celltype;
    
    allarray = [NSMutableArray array];
    
    
    if (chartview) {
        [chartview removeFromSuperview];
    }
    
    
    
    _CellModel = CellModel;
//    NSString *sensorname = [NSString stringWithFormat:@"%@:%.2f%@",_CellModel.devicename,[_CellModel.latestvalue floatValue],_CellModel.deviceunit];
//    NSLog(@"%@",sensorname);
    
    NSArray *devicearray = _CellModel.devicevalues;
    NSArray *devicearrays = devicearray[_superrow];
    NSDictionary *devicedict = devicearrays[0];
    
    if (_xnum==1) {
        celltype=1;
        selectdata = [devicedict valueForKey:@"label"];
        devicedataarray = [devicedict valueForKey:@"devicevalues"];
        for (int i = 0; i<devicearray.count; i++) {
            NSArray *devicearrays = devicearray[i];
            NSDictionary *devicedict = devicearrays[0];
            NSArray *weekarr = [devicedict valueForKey:@"devicevalues"];
            for (int k = 0; k<weekarr.count; k++) {
                [allarray addObject: weekarr[k]];
            }
        }
    }else{
        celltype=0;
        devicedataarray = [devicedict valueForKey:@"devicevalues"];
        
        for (int i =0; i < devicearray.count; i++) {
            NSArray *allarr = [NSArray arrayWithArray:devicearray[i]];
            NSDictionary *alldict = [NSDictionary dictionaryWithDictionary:allarr[0]];
            NSArray *dvarr = [NSArray arrayWithArray:[alldict valueForKey:@"devicevalues"]];
            [allarray addObject:dvarr];
        }
        
        
        if (_xnum==0) {
            selectdata = [devicedict valueForKey:@"datestring"];
        }else{
            selectdata = [devicedict valueForKey:@"label"];
        }
    }
    
    chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(15,0, [UIScreen mainScreen].bounds.size.width-30, 148)
                                             withSource:self withStyle:celltype==1?UUChartLineStyle:UUChartBarStyle withdevicename:_CellModel.devicename withname:_CellModel.devicename withdate:selectdata];
    chartview.userInteractionEnabled = NO;
    [chartview showInView:self.contentView];}

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

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUWhite,UUWhite,UUWhite,UUWhite,UUWhite,UUBlue,UURed];
}
@end
