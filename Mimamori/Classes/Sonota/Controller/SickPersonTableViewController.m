//
//  SickPersonTableViewController.m
//  Mimamori
//
//  Created by totyu3 on 16/6/3.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SickPersonTableViewController.h"
#import "PatientDetailsTableViewController.h"
#import "SickPersonTableViewCell.h"
#import "SickPersonModel.h"

#import "MCustTool.h"


@interface SickPersonTableViewController ()

@property (strong, nonatomic) NSMutableArray *custArr;//見守られる人

@end

@implementation SickPersonTableViewController

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


-(void)viewWillDisappear:(BOOL)animated{

    [self.tableView.mj_header endRefreshing];
}

/**
 *  見守られる対象者を取得
 */
-(void)getCustList{
    
    MCustInfoParam *param = [[MCustInfoParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.hassensordata = @"0";
    
    [MCustTool custInfoWithParam:param success:^(NSArray *array) {
        
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
 *  見守られる人を削除
 */
-(void)deleteCustWithUserid0:(SickPersonModel *)cust{
    MCustDeleteParam *param = [[MCustDeleteParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.userid0 = cust.userid0;
    
    [MCustTool custDeleteWithParam:param success:^(NSString *code) {
        if ([code isEqualToString:@"200"]) {
            [self.custArr removeObject:cust];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
         NITLog(@"zwdeletecust请求失败");
    }];
}


#pragma mark - TableView Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.custArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SickPersonTableViewCell *cell = [SickPersonTableViewCell cellWithTableView:tableView];
    cell.CellModel = self.custArr[indexPath.row];
    
    [self.tableView.mj_header endRefreshing];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        SickPersonModel *cust = self.custArr[indexPath.row];
        
        [self deleteCustWithUserid0:cust];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"patientDetailsPush" sender:self];
}

#pragma mark - UIStoryboardSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"patientDetailsPush"]) {
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        PatientDetailsTableViewController * pdvc = segue.destinationViewController;
        
        // 传递模型
        SickPersonModel * selectModel = self.custArr[indexPath.row];
        
        pdvc.person = selectModel;
        
    }
}

- (IBAction)addCustButton:(id)sender {
    
    [self performSegueWithIdentifier:@"addCustPush" sender:self];
    
}


@end
