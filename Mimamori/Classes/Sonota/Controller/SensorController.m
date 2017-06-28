//
//  SensorController.m
//  Mimamori
//
//  Created by NISSAY IT on 2016/12/14.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
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

#import "SinarioController.h"

#import <AVFoundation/AVFoundation.h>


/**
 その他＞見守り設定>個別入居者画面のコントローラ
 */
@interface SensorController ()<ScenarioVcDelegate,NowRloadDelegate>

@property (strong, nonatomic) IBOutlet UITableView         *tableView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *sensorSegment;

@property (nonatomic, assign) BOOL                         isSensorTableView;

@property (weak, nonatomic) IBOutlet UIButton             *editButton;

@property (nonatomic, assign) NSInteger                    addDataH; //追加シナリオボタンの高さ

@property (strong, nonatomic) IBOutlet UIButton           *setPushButton;

@property (nonatomic, strong) NSMutableArray               *profileArray;  //プロフィール情報

@property (nonatomic, strong) NSMutableArray               *scenarioArray;  //シナリオ情報

@property (nonatomic, strong) NSMutableArray               *sensorArray;    //センサ情報

@property (strong, nonatomic) IBOutlet DropButton          *facilitiesBtn;
@property (strong, nonatomic) IBOutlet UILabel             *titleLabel;

@property (strong, nonatomic) IBOutlet UIView              *footView;       //更新センサ情報 のボタン

@property (nonatomic, assign) BOOL                         isEdit;       //編集状態

@end

@implementation SensorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.footView.height = 0;
    self.footView.alpha = 0;
    
    self.isEdit = NO;
    self.titleLabel.text = self.titleStr;
    
    NSArray *arr = nil;
    [NITUserDefaults setObject:arr forKey:@"mainondedatakey"];  //クリア  mainonde
    
    [self.sensorSegment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} forState:UIControlStateNormal];
    

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getScenarioList)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    //SensorTableView 表示している
    self.isSensorTableView = YES;
    
    self.addDataH = 0;
    
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
    [self.tableView.mj_header beginRefreshing];
}


- (IBAction)saveNow:(id)sender {
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    //    sensorallnodes
    MScenarioListParam *param = [[MScenarioListParam alloc]init];
    param.staffid = [NITUserDefaults objectForKey:@"userid1"];
    param.custid = self.profileUser0;
    param.facilitycd  = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    param.floorno = self.floorno;
    
    NSDictionary *maindic = [NITUserDefaults objectForKey:@"mainondedatakey"];
    NSString *mainid = maindic[@"mainnodeid"];
    
    if (mainid.length) {
        param.mainnodeid = mainid;
        param.mainnodename = [NSString stringWithFormat:@"%@ (%@)", maindic[@"mainnodename"],maindic[@"mainnodeplace"]];
    }
    
    
    NSArray *array = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"sensorallnodes"]]];
    
    NSError *parseError = nil;
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    param.place = str;
    
    //    NITLog(@"userid1:%@\n userid0:%@\n place:%@",param.userid1,param.userid0,param.place);
    [MScenarioTool sensorUpdateWithParam:param success:^(NSString *code) {
        
        NITLog(@"%@",code);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        self.footView.height = 0;
        self.footView.alpha = 0;
        self.isEdit = NO;
        
        [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
        
        [self.tableView reloadData];
        
        [self saveNodeIdDatas];
        [self getScenarioList];
        [MBProgressHUD showSuccess:@"設定済み"];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];

}


- (IBAction)editCell:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"編集"]) {
        [sender setTitle:@"完了" forState:UIControlStateNormal];
        self.footView.height = 36;
        self.footView.alpha = 1;
        self.isEdit = YES;
    }else{
        [self saveNow:nil]; 
        
    }
    [self.tableView reloadData];
}

/**
 * プロフィール情报
 */
-(void)getProfileInfo{
    
    MProfileInfoParam *param = [[MProfileInfoParam alloc]init];
    
    param.custid = self.profileUser0;
    
    [MProfileTool profileInfoWithParam:param success:^(NSArray *array) {
        
        [MBProgressHUD hideHUDForView:self.view];
        if (array.count > 0){
            self.profileArray = [ProfileModel mj_objectArrayWithKeyValuesArray:array];
            
            ProfileModel *mod = self.profileArray.firstObject;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                if (mod.picpath.length > 0) {
                    
                    NSURL * url = [NSURL URLWithString:mod.picpath];
                    
                    NSData * data = [[NSData alloc]initWithContentsOfURL:url];
                    
                    if (data != nil) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [MBProgressHUD hideHUDForView:self.view];
                            [NITUserDefaults setObject:data forKey:self.profileUser0];
                            
                        });
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [MBProgressHUD hideHUDForView:self.view];
                            
                        });
                    }
                }
                
            });
            
        } else {
            NITLog(@"getcustinfo空");
        }
        
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view];
        NITLog(@"getcustinfo失败");
    }];
    
}


/**
 * sensor  / シナリオ  一覧取得
 */
-(void)getScenarioList{
    
    MScenarioListParam *param = [[MScenarioListParam alloc]init];
    
    param.staffid = [NITUserDefaults objectForKey:@"userid1"];
    
    param.custid = self.profileUser0;
    
    [MScenarioTool scenarioListWithParam:param success:^(NSArray *array) {
        
        [self getProfileInfo];
        
        if (array.count > 0) {
            
            NSDictionary *dic = array.firstObject;
            
            NSArray *sensorarray = dic[@"sensorplacelist"];
            
            NSArray *scenarioarray = dic[@"scenariolist"];
            
            NSArray *displays = dic[@"displaylist"];
            
            [NITUserDefaults setObject:displays forKey:@"tempdisplaylist"];
            
            self.scenarioArray = [NSMutableArray arrayWithArray:[Scenario mj_objectArrayWithKeyValuesArray:scenarioarray]];
            
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:sensorarray];
            [NITUserDefaults setObject:data forKey:@"sensorallnodes"];
            
            self.sensorArray = [NSMutableArray arrayWithArray:sensorarray];
            
            [self saveNodeIdDatas];
            
        }
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self getProfileInfo];
        
        NSArray *sensordatas = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"sensorallnodes"]]];
        
        NSArray *arr = [NITUserDefaults objectForKey:@"tempdisplaylist"];
        
        sensordatas = nil;
        arr = nil;
        
        [NITUserDefaults setObject:arr forKey:@"tempdisplaylist"];
        [NITUserDefaults setObject:sensordatas forKey:@"sensorallnodes"]; //清空 本地sensor数据，防止请求失败读上次缓存。
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
    }];
    
}



/**
 *  シナリオ削除
 */
-(void)deleteScenario:(NSString *)scenarioID{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    MScenarioDeleteParam *param = [[MScenarioDeleteParam alloc]init];
    
    param.scenarioid = scenarioID;
    
    [MScenarioTool scenarioDeleteWithParam:param success:^(NSString *code) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if ([code isEqualToString:@"200"]) {
            
            [MBProgressHUD showSuccess:@"削除済み"];
            
            [self  getScenarioList];
            
        } else {
            
            NITLog(@"deleteScenario删除失败");
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NITLog(@"deleteScenario删除失败");
    }];
}


#pragma mark - ScenarioVcDelegate

-(void)warningScenarioAddedShow:(NSString *)message{
    
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




- (IBAction)selectAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0){
        self.isSensorTableView = YES;
        self.editButton.hidden = NO;
        self.addDataH = 0;
        
    } else {
        self.editButton.hidden = YES;
        [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
        self.isEdit = NO;
        self.footView.height = 0;
        self.footView.alpha = 0;
        self.isSensorTableView = NO;
        self.addDataH = 45;
    }
    
    [self.tableView reloadData];
    
}


/**
  ローカルキャッシュ （displayname-nodeid-nodetype）
 */
- (void)saveNodeIdDatas {
    NSMutableArray *arr = [NSMutableArray new];
    NSArray *sensorarray = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"sensorallnodes"]]];
    
    if (sensorarray.count == 0) return;
    
    for (int i = 0; i< sensorarray.count ; i++) {
        NSDictionary *sensordic = sensorarray[i];
        NSDictionary *tmpdic = @{@"displayname":sensordic[@"displayname"],@"idx":[NSString stringWithFormat:@"%d",i]};
        [arr addObject:tmpdic];
    }
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    
    [NITUserDefaults setObject:data forKey:@"addnodeiddatas"];
    
}

- (IBAction)GoInSetVC:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"profilePush" sender:self];
    
}


/**
 Push ->   KVC値渡す
 */
// profile Push   / scenario Info Push   / add new scenario Push
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SinarioController *src = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"profilePush"]) {
        
        ProfileTableViewController * ptvc = segue.destinationViewController;
        
        ptvc.userid0 = self.profileUser0;
        
        ptvc.titleStr = @"プロフィール設定";
        
        ptvc.pmodel = self.profileArray.firstObject;
        
        
    } else if ([segue.identifier isEqualToString:@"scenarioInfoPush"]) {
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        Scenario *sar = self.scenarioArray[indexPath.row];
        
        src.roomID = self.roomID;
        
        src.scenarioID = sar.scenarioid;
        
        src.isRefresh = YES;
        
        src.textname = sar.scenarioname;
        
        src.user0name = self.profileUser0name;
        
        src.user0 = self.profileUser0;
        
        src.starttime = sar.starttime;
        
        src.endtime = sar.endtime;
        
        src.scopecd = sar.scopecd;
        
        src.delegate = self;
        
    } else {
        
        src.user0 = self.profileUser0;
        
        src.roomID = self.roomID;
        
        src.isRefresh = NO;;
    }
}


//tableviewcell削除
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
        SensorSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sensorcell" forIndexPath:indexPath];
        
        NSArray *arr = [Device mj_objectArrayWithKeyValuesArray:[NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"sensorallnodes"]]]];
        
        Device *devices = arr[indexPath.row];
        
        cell.cellnumber = indexPath.row;
        
        cell.SuperEdit = self.isEdit;
        
        cell.delegate = self;
        
        cell.sensorname.text = devices.nodename;
        
        [cell.pickBtn setTitle:devices.displayname forState:UIControlStateNormal];
        
        cell.roomname.text = devices.memo;
        
        cell.nodeid = devices.nodename;
        
        
        [cell.segmentbar setSelectedSegmentIndex:[devices.place integerValue] - 1];
        
        if ([devices.nodename isEqualToString:devices.mainnodeid]) {
            
            cell.sensorname.textColor = TextSelectColor;
            
        } else {
            
            cell.sensorname.textColor = [UIColor blackColor];
        }
        
        
        return cell;
    } else {
        AddTableViewCell *cell = [AddTableViewCell cellWithTableView:tableView];
        
        Scenario *sc = self.scenarioArray[indexPath.row];
        
        cell.titlename.text = sc.scenarioname;
        
        cell.sendtime.text = sc.updatedate;
        
        return cell;
    }
    
}



/**
 delegate   更新
 */
-(void)NowRefreshScreen {
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isSensorTableView) {
        [self performSegueWithIdentifier:@"scenarioInfoPush" sender:self];
    }
    
}



/**
 カスタマイズ   tableViewHeader
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.tableView.width,45)];
    
        
    UIButton *editButton =[[UIButton alloc] initWithFrame:CGRectMake(self.tableView.width - 55, 5, 40, 35)];
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
