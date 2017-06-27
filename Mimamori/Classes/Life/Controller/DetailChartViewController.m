//
//  DetailChartViewController.m
//  Mimamori
//
//  Created by NISSAY IT on 16/9/26.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "DetailChartViewController.h"
#import "DetailChartCell.h"
#import "ZworksChartModel.h"

#import "MSensorDataTool.h"

/**
 入居者一覧＞日単位グラフ＞温度・湿度・明るさのグラフ画面のコントローラ
 */
@interface DetailChartViewController ()

@end

@implementation DetailChartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return self.subdeviceinfo.count;
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailChartCell *cell = [DetailChartCell cellWithTableView:tableView];
    
    cell.dateStr = self.dateString;
    cell.nodeID = self.nodeId;
    if (self.subdeviceinfo.count >0) {
        cell.chartdic = [self.subdeviceinfo[indexPath.row] firstObject];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
    
}

@end
