//
//  AriScenarioController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/1/13.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "AriScenarioController.h"

#import "DetailCCell.h"

#import "LifeChartController.h"

@interface AriScenarioController ()<DropClickDelegate>
@property (strong, nonatomic) IBOutlet UITableView           *tableView;

@property (strong, nonatomic) IBOutlet UILabel               *aratoUser;

@property (strong, nonatomic) IBOutlet UIButton              *pushButton;

@property (nonatomic, strong) NSMutableArray                 *alldatas;

@property (nonatomic, strong) NSString                       *roomname;

@property (strong, nonatomic) IBOutlet DropButton            *facilitiesBtn;


@end

@implementation AriScenarioController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *string = [NSString stringWithFormat:@"<アラート>%@",self.username];
    
    self.aratoUser.text = string;
    
    [self.pushButton setEnabled:NO];
    [self.pushButton setBackgroundColor:NITColor(169, 169, 169)];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(detailRefresh)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    
    [MBProgressHUD showMessage:@"" toView:self.view];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}

/**
 弹出下拉设施菜单
 @param sender
 */
- (void)detailRefresh {
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    
    parametersDict[@"custid"] = self.usernumber;
    
    parametersDict[@"subtitle"] = self.subtitle;
    
    parametersDict[@"noticetype"] = @"1";
    
    [MHttpTool postWithURL:NITGetNoticeInfo params:parametersDict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        
        [self.tableView.mj_header endRefreshing];
        
        NSArray *tmparr = json[@"notices"];
        
        self.alldatas = [NSMutableArray arrayWithArray:tmparr];
        
        if (self.alldatas.count > 0) {
            
            [self.pushButton setEnabled:YES];
            
            [self.pushButton setBackgroundColor:NITColor(252, 82, 116)];
            
            self.roomname = [[[self.alldatas.firstObject firstObject] firstObject] objectForKey:@"roomname"];
            
            [self.tableView reloadData];
            
        } else {
            NITLog(@"aratoinfo没数据");
        }
        
        
    } failure:^(NSError *error) {
        NITLog(@"aratoinfo请求失败:%@",[error localizedDescription]);
        [MBProgressHUD hideHUDForView:self.view];
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}

- (IBAction)PushOrPopAction:(UIButton *)sender {
    if (self.isPushOrPop) {
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        UIStoryboard *lifeStoryBoard = [UIStoryboard storyboardWithName:@"Life" bundle:nil];
        
        LifeChartController *lcc = [lifeStoryBoard instantiateViewControllerWithIdentifier:@"LifeChartCID"];
        lcc.ariresult = @"異常検知あり";
        lcc.username = self.username;
        lcc.userid0 = self.usernumber;
        
        NSString *strtt = [NSString stringWithFormat:@"%@(%@)",self.username,self.roomname];
        lcc.viewTitle = strtt;
        lcc.roomID = self.roomname;
        //跳转事件
        [self.navigationController pushViewController:lcc animated:YES];
    }
    
}

#pragma mark - UITableView dataSource and delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.alldatas.count;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.alldatas[section];
    
    return array.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailCCell *cell = [DetailCCell cellWithTableView:tableView];
    
    NSDictionary *dic = nil;
    
    NSArray *dicarr = nil;
    
    NSArray *arr = self.alldatas[indexPath.section];
    
    dicarr  = arr[indexPath.row];
   
    dic = dicarr.firstObject;
    
    if (dicarr.count >0) {
        
        cell.devicename.text = dic[@"devicename"];
        
        NSString *stringtime = [NSString stringWithFormat:@"%@H",dic[@"time"]];
        
        cell.timeValue.text = stringtime;
        
        NSString *strvalue = dic[@"value"];
        
        if ([strvalue isEqualToString:@"0"]) {
            NSString *stringR = [NSString stringWithFormat:@"%@%@",dic[@"unit"],dic[@"rpoint"]];
            cell.valueRp.text = stringR;
        } else {
            NSString *stringR = [NSString stringWithFormat:@"%@%@%@",dic[@"value"],dic[@"unit"],dic[@"rpoint"]];
            cell.valueRp.text = stringR;
        }
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NITScreenW, 25)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, (NITScreenW - 30) *0.4, 25)];
    
    UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(NITScreenW *0.3 + 15, 0,NITScreenW - label.width - 15, 25)];
    timelabel.font = [UIFont systemFontOfSize:15];
    
    [label setAdjustsFontSizeToFitWidth:YES];
    [timelabel setAdjustsFontSizeToFitWidth:YES];
    
    [timelabel setTextAlignment:NSTextAlignmentRight];
    
    [bgview addSubview:label];
    [bgview addSubview:timelabel];
    
    NSArray *dicarr = nil;
    
    dicarr = [self.alldatas[section] firstObject];
    
    if (dicarr.count >0) {
        
        timelabel.text = [dicarr. firstObject objectForKey:@"registdate"];
        
        label.text = [dicarr.firstObject objectForKey:@"scenarioname"];
        
        return bgview;
        
    } else {
        
        return nil;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
