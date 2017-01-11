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

@interface SetController ()

@property (nonatomic, strong) NSArray                  *userarray;

@property (nonatomic, strong) NSArray                  *numarray;

@property (strong, nonatomic) NSMutableArray *custArr;//見守られる人

@end

@implementation SetController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCustList)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.tableView.mj_header beginRefreshing];
}



/**
 *  見守られる対象者を取得
 */
-(void)getCustList{
    
    MCustInfoParam *param = [[MCustInfoParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.hassensordata = @"0";
    
    [MCustTool custInfoWithParam:param success:^(NSArray *array) {
        [self.tableView.mj_header endRefreshing];
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

//- (IBAction)addCustButton:(id)sender {
//    
//    [self performSegueWithIdentifier:@"addCustPush" sender:self];
//    
//}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"setcellpush"]) {
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        SensorController *ssc = segue.destinationViewController;
        
        // 传递模型
        SickPersonModel * selectModel = self.custArr[indexPath.row];
        
        ssc.profileUser0 = selectModel.userid0;
        
        ssc.profileUser0name = selectModel.user0name;
        
        ssc.title = selectModel.dispname;
        
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
    
    NSString *strname = [NSString stringWithFormat:@"%@(%@)",tmpmodel.user0name,tmpmodel.roomname];
    
    cell.userinfolabel.text = strname;
    
    cell.sensernumber.text = tmpmodel.sensorcount;
    
    return cell;
}


//tableviewcell点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"setcellpush" sender:self];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
