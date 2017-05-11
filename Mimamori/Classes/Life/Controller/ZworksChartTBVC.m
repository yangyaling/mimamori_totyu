//
//  ZworksChartTBVC.m
//  見守る側
//
//  Created by totyu3 on 16/11/16.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "ZworksChartTBVC.h"
#import "ZworksChartModel.h"
#import "ZworksChartVTBCell.h"


#import "DetailScrollController.h"

@interface ZworksChartTBVC ()

@end

@implementation ZworksChartTBVC


- (void)viewDidLoad {
    [super viewDidLoad];

//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(popReloadList)];
    [NITRefreshInit MJRefreshNormalHeaderInitTwo:(MJRefreshNormalHeader*)self.tableView.mj_header];
}

- (void)popReloadList {
    
    [self.updatedelegate updateCorrentTB:self.xnum];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
//    CGFloat setx = [NITUserDefaults floatForKey:@"oneoffSetx"];
//    CGFloat sety = [NITUserDefaults floatForKey:@"oneoffSety"];

//    [self.tableView setContentOffset:CGPointMake(setx, sety)];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    [NITUserDefaults setFloat:scrollView.contentOffset.y forKey:@"oneoffSety"];
//    [NITUserDefaults setFloat:scrollView.contentOffset.x forKey:@"oneoffSetx"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZworksChartVTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZworksTBCell"];
    
    cell.xnum = _xnum;
    
    cell.superrow = _superrow;
    
    NSDictionary *dic = _zarray[_superrow];
    
    if (dic.count >0) {
//        NSString *str1 = [NSString stringWithFormat:@"%@",dic[@"datestring"]];
        cell.datestr = dic[@"datestring"];
        cell.labelstr = dic[@"label"];
    }
//    NSArray *array = [ZworksChartModel mj_objectArrayWithKeyValuesArray:arr];
//    
//    NSArray *cellarray = array[indexPath.section];
//    
//    cell.CellModel =  cellarray.count > 0 ? [ZworksChartModel mj_objectWithKeyValues:cellarray] : nil;
    NSArray *cellarr = dic[@"deviceinfo"];
    
    if (cellarr.count > 0) {
        cell.cellarr = cellarr[indexPath.section];
    }
//    cell.celldic = arr.count > 0 ?  arr[indexPath.section] : nil;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_xnum==0)[self performSegueWithIdentifier:@"zworksDetailsPush" sender:self];
}

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
//    NSArray *arr = [_zarray[section] objectForKey:@"deviceinfo"];
//    NSDictionary *dic = arr[section];
//    NSArray *array = [ZworksChartModel mj_objectArrayWithKeyValuesArray:arr];
//    ZworksChartModel *model = [ZworksChartModel mj_objectWithKeyValues:array[section]];
    return bgview;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"zworksDetailsPush"]){
        DetailScrollController *zdvc = segue.destinationViewController;
        NSIndexPath *index = self.tableView.indexPathForSelectedRow;
        NSDictionary *dic = _zarray[_superrow];
        NSArray *cellarr = dic[@"deviceinfo"];
        ZworksChartModel *model = [ZworksChartModel mj_objectWithKeyValues:[cellarr[index.section] firstObject]];
        
        zdvc.userid0 = _userid0;
        zdvc.chartModel = model;
        zdvc.selectindex = _superrow;
        zdvc.SumPage = 7;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
