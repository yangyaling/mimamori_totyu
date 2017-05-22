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
@property (strong, nonatomic) IBOutlet UILabel               *roomnum;
@property (strong, nonatomic) IBOutlet UILabel               *Rtime;
@property (strong, nonatomic) IBOutlet UIButton              *pushButton;

@property (nonatomic, strong) NSMutableArray                 *alldatas;

@property (nonatomic,strong) AFHTTPSessionManager            *session;

@property (nonatomic, strong) NSString                       *roomname;

@property (strong, nonatomic) IBOutlet DropButton            *facilitiesBtn;

@end

@implementation AriScenarioController


//- (IBAction)gobacktoC:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}


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
    
    self.session = [AFHTTPSessionManager manager];
    self.session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
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
-(void)showSelectedList {
    
    
}


- (void)detailRefresh {
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    
    parametersDict[@"custid"] = self.usernumber;
    
    parametersDict[@"noticetype"] = @"1";
    
    [self.session POST:NITGetNoticeInfo parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        
        [self.tableView.mj_header endRefreshing];
        NSArray *tmparr = responseObject[@"notices"];
        self.alldatas = [NSMutableArray arrayWithArray:tmparr.firstObject];
        if (self.alldatas.count >0) {
            self.Rtime.text = [self.alldatas.firstObject objectForKey:@"registdate"];
            self.roomnum.text = [self.alldatas.firstObject objectForKey:@"scenarioname"];
            self.roomname = [self.alldatas.firstObject objectForKey:@"roomname"];
            [self.pushButton setEnabled:YES];
            [self.pushButton setBackgroundColor:NITColor(252, 82, 116)];
            [self.tableView reloadData];
        } else {
            NITLog(@"aratoinfo没数据");
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alldatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailCCell *cell = [DetailCCell cellWithTableView:tableView];
    
    NSDictionary *dic = self.alldatas[indexPath.row];
    
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
    
    
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
