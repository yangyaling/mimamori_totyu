//
//  SinarioDetailController.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/15.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SinarioDetailController.h"

#import "AddTableViewCell.h"

#import "Scenario.h"
#import "MScenarioTool.h"

@interface SinarioDetailController ()

@property (nonatomic, strong) NSMutableArray               *scenarioArray;

@end

@implementation SinarioDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getScenarioList)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}



/**
 *  シナリオ一覧取得
 */
-(void)getScenarioList{
    
    MScenarioListParam *param = [[MScenarioListParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.userid0 = self.user0;
    
    [MScenarioTool scenarioListWithParam:param success:^(NSArray *array) {
        
        if (array.count > 0) {
            
            NSDictionary *dic = array.firstObject;
            
            NSArray *scenarioarray = dic[@"scenariolist"];
            
            self.scenarioArray = [NSMutableArray arrayWithArray:[Scenario mj_objectArrayWithKeyValuesArray:scenarioarray]];
            
            
        }
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scenarioArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddTableViewCell *cell = [AddTableViewCell cellWithTableView:tableView];
    
    Scenario *sc = self.scenarioArray[indexPath.row];
    
    cell.titlename.text = sc.scenarioname;
    
    cell.sendtime.text = sc.updatedate;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
