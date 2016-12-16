//
//  PatientDetailsTableViewController.m
//  Mimamori
//
//  Created by totyu3 on 16/6/3.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "PatientDetailsTableViewController.h"
#import "ScenarioTableViewController.h"
#import "PatientDetailsTableViewCell.h"
#import "ProfileTableViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "SickPersonModel.h"
#import "NotificationModel.h"
#import "Scenario.h"
#import "MScenarioTool.h"

@interface PatientDetailsTableViewController ()<ScenarioVcDelegate>

@property int editFlag;// 0:シナリオ追加  1:シナリオ编辑
/**
 *  section数组
 */
@property (nonatomic, strong) NSMutableArray      *scenarioNameArray;



@property (nonatomic, strong) NSArray      *scenarioArray;

@property (nonatomic, strong) NSMutableArray       *alertArr;//＜センサー＞通知アイテム

@property (nonatomic, strong) NSString      *roomID;

@property (nonatomic, strong) NSString      *userid0;

@property (nonatomic, strong) Scenario      *deliverScenario;


@end

@implementation PatientDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.roomID = self.person.roomid;
    self.userid0 = self.person.userid0;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getScenarioList)];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  シナリオ一覧取得
 */
-(void)getScenarioList{
    
    MScenarioListParam *param = [[MScenarioListParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.userid0 = self.person.userid0;
    
    [MScenarioTool scenarioListWithParam:param success:^(NSArray *array) {
        if (array.count > 0) {
            self.scenarioArray = [Scenario mj_objectArrayWithKeyValuesArray:array];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
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
            [self getScenarioList];
        }
    } failure:^(NSError *error) {
        
    }];
}

//「＋」ボタンが押された時

-(void)addScenario{
    self.editFlag = 0;
    [self performSegueWithIdentifier:@"scenarioPush" sender:self];
}


#pragma mark - ScenarioVcDelegate

-(void)warningScenarioAdded:(NSString *)message{
    AudioServicesPlaySystemSound(1007);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"アラート"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *action) {
                                                
                                            }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}



#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return self.scenarioArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PatientDetailsTableViewCell *cell = [PatientDetailsTableViewCell cellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        cell.scenarioLabel.text = @"プロフィール";
    }else{
        Scenario *scenario = self.scenarioArray[indexPath.row];
        cell.scenarioLabel.text = scenario.scenarioname;
    }
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

//tableviewcell删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Scenario *model = [self.scenarioArray objectAtIndex:indexPath.row];
        [self deleteScenario:model.scenarioid];
        
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"profilePush" sender:self];
        
    }
    if (indexPath.section == 1) {
        self.editFlag = 1;
        self.deliverScenario = self.scenarioArray[indexPath.row];
        [self performSegueWithIdentifier:@"scenarioPush" sender:self];
        
    }
}

//自定义 SectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView = [[UIView alloc]init];
    
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.tableView.width,45)];
    titleView.backgroundColor = NITColor(245, 245, 245);
    
    [titleView addSubview:titleLabel];
    
    //シナリオ
    if (section ==1){
        
        UIButton *editButton =[[UIButton alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width*0.84, 0, 60, 45)];
        [editButton setTitle: @"＋" forState: UIControlStateNormal];
        [editButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(addScenario) forControlEvents:UIControlEventTouchUpInside];
        
        editButton.titleLabel.font = [UIFont systemFontOfSize: 25.0];
        titleLabel.text = @"シナリオ";
        [titleView addSubview:editButton];
        
    }else{
        titleLabel.text = self.person.dispname;
        
    }
    
    return titleView;
}

#pragma mark - UIStoryboardSegue

//segue跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    
    if ([segue.identifier isEqualToString:@"scenarioPush"]) {
        
        ScenarioTableViewController * svc = segue.destinationViewController;
        svc.delegate = self;
        svc.roomid = self.roomID;
        svc.userid0 = self.userid0;
        svc.user0name = self.person.user0name;
        svc.editType = self.editFlag;
        
        if (self.editFlag ==1) {
            svc.scenario = self.deliverScenario;
        }
    }else if([segue.identifier isEqualToString:@"profilePush"]){
        
        ProfileTableViewController * ptvc = segue.destinationViewController;
        ptvc.userid0 = self.userid0;
        
    }
    
}

@end
