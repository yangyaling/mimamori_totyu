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
    NSString *selectdate;
    UUChart *chartview;
}



@end
@implementation ZworksChartVTBCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    ZworksChartVTBCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ZworksTBCell"];
    
//    if (!cell) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"ZworksTBCell" owner:self options:nil].firstObject;
//    }
    
    return cell;
}



-(void)setCellarr:(NSArray *)cellarr {
    
    _cellarr = cellarr;
    
//    NSDictionary *tmpdic = cellarr.firstObject;
//    
//    if (tmpdic[@"nodeid"] == [NSNull null]) {
//        return;
//    }
    
    if(cellarr == nil ) return;
    
    int celltype;
    
    if (chartview) {
        [chartview removeFromSuperview];
    }
    
//    NSString *sensorname = [NSString stringWithFormat:@"%@:%.2f%@",celldic[@"devicename"],[celldic[@"latestvalue"] floatValue],celldic[@"deviceunit"]];
    //    NSLog(@"%@",sensorname);
    
    
    
//    NSString *datestring = celldic[@"datestring"];
    selectdate = nil;
    devicedataarray = nil;
    allarray = [NSMutableArray new];
    
    NSDictionary *celldic = cellarr.firstObject;
    
    if (_xnum == 0) {
        celltype=0;
        NSArray *devicevalues = [celldic objectForKey:@"devicevalues"];
        devicedataarray = devicevalues.copy;
        selectdate = self.datestr;
        [allarray addObject:devicedataarray];
        
    } else if (_xnum == 1) {
        celltype=1;
        selectdate = self.labelstr;
        NSArray *devicevalues = [celldic objectForKey:@"devicevalues"];
        devicedataarray = devicevalues.copy;
        allarray = [NSMutableArray arrayWithArray:devicedataarray];
        
    } else {
        celltype=2;
        selectdate = self.labelstr;
        NSArray *devicevalues = [celldic objectForKey:@"deviceinfo"];
        devicedataarray = devicevalues.copy;
        [allarray addObject:devicedataarray];
    }
    
//    NSArray *devicearrays = devicearray[_superrow];
    
//    NSDictionary *devicedict = devicearrays[0];
    
//    if (_xnum==2) {
//        celltype=2;
//        selectdata = [devicedict valueForKey:@"label"];
//        devicedataarray = [devicedict valueForKey:@"devicevalues"];
    
//        for (int i = 0; i<devicearray.count; i++) {
//            NSArray *devicearrays = devicearray[i];
//            NSDictionary *devicedict = devicearrays[0];
//            NSArray *weekarr = [devicedict valueForKey:@"devicevalues"];
//            for (int k = 0; k<weekarr.count; k++) {
//                [allarray addObject: weekarr[k]];
//            }
//        }
//    } else if ( _xnum ==1 ) {
//        celltype=1;
//        devicedataarray = [devicedict valueForKey:@"devicevalues"];
//        
//        for (int i =0; i < devicearray.count; i++) {
//            NSArray *allarr = [NSArray arrayWithArray:devicearray[i]];
//            NSDictionary *alldict = [NSDictionary dictionaryWithDictionary:allarr[0]];
//            NSArray *dvarr = [NSArray arrayWithArray:[alldict valueForKey:@"devicevalues"]];
//            [allarray addObject:dvarr];
//        }
        
    
//        if (_xnum==0) {
//            selectdata = [devicedict valueForKey:@"datestring"];
//        }else{
//            selectdata = [devicedict valueForKey:@"label"];
//        }
//    } else {
    
//    }
    
    chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(6,0, [UIScreen mainScreen].bounds.size.width-12, 148)
                                             withSource:self withStyle:celltype==1?UUChartLineStyle:UUChartBarStyle withdevicename:celldic[@"devicename"] withname:celldic[@"devicename"] withdate:selectdate];
    chartview.userInteractionEnabled = NO;
    [chartview showInView:self.contentView];
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
    
    
//    if (devicedataarray.count == 0) {
//        return nil;
//    }
    
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
