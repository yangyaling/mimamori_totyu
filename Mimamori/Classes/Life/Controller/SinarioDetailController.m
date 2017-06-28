//
//  SinarioDetailController.m
//  Mimamori
//
//  Created by NISSAY IT on 2016/12/15.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "SinarioDetailController.h"

#import "AddTableViewCell.h"

#import "Scenario.h"
#import "MScenarioTool.h"

#import "SinarioController.h"

/**
 シナリオ一覧
 */
@interface SinarioDetailController ()<DropClickDelegate>

@property (nonatomic, strong) NSMutableArray                 *scenarioArray; //シナリオ  データ
@property (strong, nonatomic) IBOutlet UITableView           *tableView;
@property (strong, nonatomic) IBOutlet DropButton            *facilitiesBtn;
@end

@implementation SinarioDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getScenarioList)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];//更新施設名２
}

/**
 施設切替後 -> pop to root ViewController
 */
-(void)SelectedListName:(NSDictionary *)clickDic {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  シナリオ一覧取得
 */
-(void)getScenarioList{
    
    MScenarioListParam *param = [[MScenarioListParam alloc]init];
    param.staffid = [NITUserDefaults objectForKey:@"userid1"];
    param.custid = self.user0;
    
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


/**
 セルをクリック   -> KVO プッシュ
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *lifeStoryBoard = [UIStoryboard storyboardWithName:@"Sonota" bundle:nil];
    
    SinarioController *svc = [lifeStoryBoard instantiateViewControllerWithIdentifier:@"PushSinarioC"];
    
    Scenario *sc = self.scenarioArray[indexPath.row];
    
    svc.roomID = self.roomId;
    
    svc.scenarioID = sc.scenarioid;
    
    svc.isRefresh = YES;
    
    svc.textname = sc.scenarioname;
    
    svc.user0 = self.user0;
    
    svc.starttime = sc.starttime;
    
    svc.endtime = sc.endtime;
    
    svc.scopecd = sc.scopecd;
    
    svc.hideBarButton = YES;
    
//    svc.delegate = self;
    
    //push ->シナリオ詳細
    [self.navigationController pushViewController:svc animated:YES];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
