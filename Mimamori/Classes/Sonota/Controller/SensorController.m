//
//  SensorController.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SensorController.h"


#import "SensorSetTableViewCell.h"

#import "AddTableViewCell.h"

#import "ProfileTableViewController.h"

#import "ProfileModel.h"

#import "MProfileTool.h"

#import "Scenario.h"

#import "MScenarioTool.h"

#import "Device.h"

#import "AFNetworking.h"

@interface SensorController ()

@property (strong, nonatomic) IBOutlet UITableView         *tableView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *sensorSegment;

@property (strong, nonatomic) IBOutlet UIButton           *saveButton;

@property (nonatomic, assign) BOOL                         isSensorTableView;


@property (nonatomic, assign) NSInteger                    addDataH;

@property (strong, nonatomic) IBOutlet UIButton           *setPushButton;

@property (nonatomic, strong) NSMutableArray               *profileArray;

@property (nonatomic, strong) NSMutableArray               *scenarioArray;

@property (nonatomic, strong) NSMutableArray               *sensorArray;

@end

@implementation SensorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.saveButton.layer.cornerRadius = 6;
    
    self.setPushButton.layer.cornerRadius = 6;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.sensorSegment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} forState:UIControlStateNormal];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getScenarioList)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    self.isSensorTableView = YES;
    self.addDataH = 0;
    
    [self getProfileInfo];
    [MBProgressHUD showMessage:@"" toView:self.view];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView.mj_header beginRefreshing];
}

/**
 * プロフィール情报
 */
-(void)getProfileInfo{
    
    MProfileInfoParam *param = [[MProfileInfoParam alloc]init];
    
    param.userid0 = self.profileUser0;
    
    [MProfileTool profileInfoWithParam:param success:^(NSArray *array) {
        [MBProgressHUD hideHUDForView:self.view];
        if (array.count > 0){
            self.profileArray = [ProfileModel mj_objectArrayWithKeyValuesArray:array];
            ProfileModel *mod = self.profileArray.firstObject;
            NSData *dataicon = [NSData dataWithContentsOfURL:[NSURL URLWithString:mod.picpath]];
            [NITUserDefaults setObject:dataicon forKey:self.profileUser0];
            
        } else {
            NITLog(@"getcustinfo空");
        }
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
        NITLog(@"getcustinfo失败");
    }];
    
}


/**
 *  シナリオ一覧取得
 */
-(void)getScenarioList{
    
    MScenarioListParam *param = [[MScenarioListParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.userid0 = self.profileUser0;
    
    [MScenarioTool scenarioListWithParam:param success:^(NSArray *array) {
        
        if (array.count > 0) {
//            NITLog(@"scenarioList:%@",array);
            NSDictionary *dic = array.firstObject;
            
            self.scenarioArray = [NSMutableArray arrayWithArray:[Scenario mj_objectArrayWithKeyValuesArray:dic[@"scenariolist"]]];
            
            [NITUserDefaults setObject:dic[@"sensorplacelist"] forKey:@"sensorallnodes"];
            
            self.sensorArray = [NSMutableArray arrayWithArray:[Device mj_objectArrayWithKeyValuesArray:[NITUserDefaults objectForKey:@"sensorallnodes"]]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

/**
 *  シナリオ削除
 */
-(void)deleteScenario:(NSString *)scenarioID{
    
    MScenarioDeleteParam *param = [[MScenarioDeleteParam alloc]init];
    param.scenarioid = scenarioID;
    
    [MScenarioTool scenarioDeleteWithParam:param success:^(NSString *code) {
        if ([code isEqualToString:@"200"]) {
            
            
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}


- (IBAction)selectAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0){
        self.isSensorTableView = YES;
        self.saveButton.hidden = NO;
        self.tableView.frame = CGRectMake(0, 141 , NITScreenW, NITScreenH - 250);
        self.addDataH = 0;
        
    } else {
        self.saveButton.hidden = YES;
        self.isSensorTableView = NO;
        self.tableView.frame = CGRectMake(0, 141 , NITScreenW, NITScreenH - 190);
        self.addDataH = 45;
    }
    
    [self.tableView reloadData];
    
}

- (IBAction)SaveSelectedData:(UIButton *)sender {
//    sensorallnodes
    MScenarioListParam *param = [[MScenarioListParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.userid0 = self.profileUser0;
    
    NSArray *array = [NITUserDefaults objectForKey:@"sensorallnodes"];
    NSError *parseError = nil;
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    param.place = str;
    
    AFHTTPSessionManager *manager =  [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    
    [manager POST:NITUpdateSensorInfo parameters:param.mj_keyValues progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NITLog(@"zwupdatescenarioinfo success %@",responseObject);
        //追加成功，显示信息
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
//    [MScenarioTool sensorUpdateWithParam:param success:^(NSString *code) {
//        NITLog(@"%@",code);
//    } failure:^(NSError *error) {
//        
//    }];
    
}
- (IBAction)GoInSetVC:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"profilePush" sender:self];
    
    
}



//segue跳转 profilePush
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"profilePush"]) {
        
        ProfileTableViewController * ptvc = segue.destinationViewController;
        ptvc.userid0 = self.profileUser0;
        ptvc.pmodel = self.profileArray.firstObject;
        
    }
    
}


//tableviewcell删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Scenario *model = [self.scenarioArray objectAtIndex:indexPath.row];
        [self.scenarioArray removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [self deleteScenario:model.scenarioid];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSensorTableView) {
        return self.sensorArray.count;
    } else {
        return self.scenarioArray.count;
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isSensorTableView) {
        return YES;
    } else {
        return NO;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSensorTableView) {
        SensorSetTableViewCell *cell = [SensorSetTableViewCell cellWithTableView:tableView];
        
        
        NSArray *arr = [Device mj_objectArrayWithKeyValuesArray:[NITUserDefaults objectForKey:@"sensorallnodes"]];
        
        Device *devices = arr[indexPath.row];
        cell.cellnumber = indexPath.row;
        cell.sensorname.text = devices.nodename;
        [cell.roomname setTitle:devices.displayname forState:UIControlStateNormal];
        [cell.segmentbar setSelectedSegmentIndex:[devices.place integerValue]];
        cell.device = devices;
        return cell;
    } else {
        AddTableViewCell *cell = [AddTableViewCell cellWithTableView:tableView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isSensorTableView) {
        [self performSegueWithIdentifier:@"scenarioPush" sender:self];
    }
    
}
//
//自定义 SectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.tableView.width,45)];
//    titleView.backgroundColor = NITColor(235, 235, 235);
    
    //シナリオ
        
    UIButton *editButton =[[UIButton alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width*0.85, 5, 40, 35)];
    [editButton setTitle: @"＋" forState: UIControlStateNormal];
    [editButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(addScenario:) forControlEvents:UIControlEventTouchUpInside];
    
    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:36.0];
    editButton.layer.cornerRadius = 5;
    editButton.layer.borderWidth = 1.3;
    editButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [titleView addSubview:editButton];
    
    return titleView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.addDataH;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)addScenario:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"scenarioPush" sender:self];
}

@end
