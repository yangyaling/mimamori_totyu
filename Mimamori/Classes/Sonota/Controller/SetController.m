//
//  SetController.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SetController.h"

#import "SetTableViewCell.h"

#import "SensorController.h"

#import "SickPersonModel.h"

#import "MCustTool.h"


/**
 見守り設定
 */
@interface SetController ()<DropClickDelegate>


@property (strong, nonatomic) NSMutableArray                 *custArr;//見守られる人

@property (strong, nonatomic) IBOutlet DropButton            *facilitiesBtn;

@property (strong, nonatomic) IBOutlet UITableView           *tableView;

@end

@implementation SetController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCustList)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
    [self.tableView.mj_header beginRefreshing];
}

/**
 切替施設  delegate
 */
-(void)SelectedListName:(NSDictionary *)clickDic; {
    
    [self.tableView.mj_header beginRefreshing];
}


/**
 *  見守られる対象者を取得
 */
-(void)getCustList{
    
    MCustInfoParam *param = [[MCustInfoParam alloc]init];
    param.staffid = [NITUserDefaults objectForKey:@"userid1"];
    param.facilitycd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    param.hassensordata = @"0";
    
    [MCustTool custInfoWithParam:param success:^(NSArray *array) {
        [self.tableView.mj_header endRefreshing];
        self.custArr = [NSMutableArray new];
        if (array.count == 0) {
            [MBProgressHUD showError:@"見守り対象者を追加してください"];
            [self.tableView.mj_header endRefreshing];
        }
        if (array) {
            NSArray *tmpArr = [SickPersonModel mj_objectArrayWithKeyValuesArray:array];
            self.custArr= tmpArr.count ? [NSMutableArray arrayWithArray:tmpArr] : [NSMutableArray new];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NITLog(@"zwgetcustlist请求失败");
        [self.tableView.mj_header endRefreshing];
    }];
}



/**
 Push ->   KVC値渡す
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"setcellpush"]) {
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        SensorController *ssc = segue.destinationViewController;
        
        // 传递模型
        SickPersonModel * selectModel = self.custArr[indexPath.row];
        
        ssc.profileUser0 = selectModel.userid0;
        
        ssc.floorno = selectModel.floorno;
        
        ssc.profileUser0name = selectModel.user0name;
        NSString *strtt = [NSString stringWithFormat:@"%@(%@)",selectModel.user0name,selectModel.roomid];
        ssc.titleStr = strtt;
        
        ssc.roomID = selectModel.roomid;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.custArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SetTableViewCell *cell = [SetTableViewCell cellWithTableView:tableView];
    
    SickPersonModel *tmpmodel = self.custArr[indexPath.row];
    
    NSString *strname = [NSString stringWithFormat:@"%@(%@)",tmpmodel.user0name,tmpmodel.roomid];
    
    cell.userinfolabel.text = strname;
    
    cell.sensernumber.text = tmpmodel.sensorcount;
    
    return cell;
}


//tableviewcell  push 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"setcellpush" sender:self];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
