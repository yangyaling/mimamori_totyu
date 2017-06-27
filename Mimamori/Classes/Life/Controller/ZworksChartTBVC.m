//
//  ZworksChartTBVC.m
//  見守る側
//
//  Created by NISSAY IT on 16/11/16.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "ZworksChartTBVC.h"
#import "ZworksChartModel.h"
#import "ZworksChartVTBCell.h"


#import "DetailScrollController.h"


/**
 入居者一覧＞個別入居者のグラフがスクロールできるようにするコントローラ
 */
@interface ZworksChartTBVC ()

@end

@implementation ZworksChartTBVC


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(popReloadList)];
    [NITRefreshInit MJRefreshNormalHeaderInitTwo:(MJRefreshNormalHeader*)self.tableView.mj_header];
}



/**
  refresh  delegate
 */
- (void)popReloadList {
    
    //デリゲートの転送
    [self.updatedelegate updateCorrentTB:self.xnum];
    
}

-(void)viewWillAppear:(BOOL)animated{
}

#pragma mark UITableView delegate and dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSDictionary *dic = _zarray[_superrow];
    NSArray *cellarr = dic[@"deviceinfo"];
    return cellarr.count;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZworksChartVTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZworksTBCell"];
    
    cell.xnum = _xnum;
    
    cell.superrow = _superrow;
    
    NSDictionary *dic = _zarray[_superrow];
    
    if (dic.count >0) {
        cell.datestr = dic[@"datestring"];
        cell.labelstr = dic[@"label"];
    }
    NSArray *cellarr = dic[@"deviceinfo"];
    
    if (cellarr.count > 0) {
        cell.cellarr = cellarr[indexPath.section];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_xnum==0)[self performSegueWithIdentifier:@"zworksDetailsPush" sender:self];
}



/**
 

 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *dic = _zarray[_superrow];
    
    NSArray *cellarr = dic[@"deviceinfo"];
    
    CGRect frame = CGRectMake(10, 0, NITScreenW -20, 25);
    CGRect labelframe = CGRectMake(NITScreenW * 0.1, 0, NITScreenW * 0.8, 25);
    CGRect imageframe = CGRectMake(NITScreenW * 0.9, 2, 20, 20);
    UIView *bgview = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [[UILabel alloc]initWithFrame:labelframe];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:imageframe];
    [imageV setContentMode:UIViewContentModeScaleAspectFit];
    bgview.backgroundColor =  [[UIColor lightGrayColor]colorWithAlphaComponent:0.1];
    
    if (cellarr.count >0) {
        
        NSDictionary *tmpdic = [cellarr[section] firstObject];
        
        if (tmpdic[@"nodeid"] == [NSNull null]) {
            return bgview;
        }
        
        ZworksChartModel *model = [ZworksChartModel mj_objectWithKeyValues:[cellarr[section] firstObject]];
        
        [label setText:[NSString stringWithFormat:@"%@（%@）%@",model.devicename,model.nodename,model.displayname]];
        
        [label setText:[NSString stringWithFormat:@"%@（%@）%@",model.devicename,model.nodename,model.displayname]];
        
        [label setFont:[UIFont systemFontOfSize:14]];
        label.textAlignment = NSTextAlignmentCenter; //居中文字
        if ([model.batterystatus intValue] == 1) {
            [imageV setImage:[UIImage imageNamed:@"battery_full"]];
        }else if ([model.batterystatus intValue] == 2){
            [imageV setImage:[UIImage imageNamed:@"battery_warn"]];
        }else if ([model.batterystatus intValue] == 3){
            [imageV setImage:[UIImage imageNamed:@"battery_empty"]];
        }
        [bgview addSubview:label];
        [bgview addSubview:imageV];
        
    }
    
    return bgview;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"zworksDetailsPush"]){
        DetailScrollController *zdvc = segue.destinationViewController;
        NSIndexPath *index = self.tableView.indexPathForSelectedRow;
        NSDictionary *dic = _zarray[_superrow];
        NSArray *cellarr = dic[@"deviceinfo"];
        NSString *datestring = dic[@"datestring"];
        ZworksChartModel *model = [ZworksChartModel mj_objectWithKeyValues:[cellarr[index.section] firstObject]];
        zdvc.datestring = datestring;
        zdvc.userid0 = _userid0;
        zdvc.chartModel = model;
        zdvc.selectindex = _superrow;
        zdvc.SumPage = 7;
    }
    
}

@end
