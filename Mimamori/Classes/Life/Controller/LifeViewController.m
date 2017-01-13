//
//  LifeViewController.m
//  Mimamori
//
//  Created by totyu3 on 16/6/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "LifeChartController.h"

#import "LifeViewController.h"
#import "LifesTableViewCell.h"
#import "LifeUserListModel.h"

#import "AddNursingViewController.h"
#import "NursingNotesTableViewController.h"

//#import "ZworksChartViewController.h"

#import "MCustTool.h"

@interface LifeViewController ()<LifesTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UITableView *lifeTableView;

@property (nonatomic,strong) LifeUserListModel          *deliverModel;

@property (strong, nonatomic) NSMutableArray            *custArr; //LifeUserListModel模型数组

@property (nonatomic, assign) int                       segmentNum;

@end

@implementation LifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // SegmentedControlのフォントを設定
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    // 空のセルを表示させない
    self.lifeTableView.tableFooterView = [[UIView alloc]init];
    
    self.lifeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCustList)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.lifeTableView.mj_header];
    
    self.segmentNum = 0;
}


-(void)viewWillAppear:(BOOL)animated{

    [self.lifeTableView.mj_header beginRefreshing];
}



-(void)viewWillDisappear:(BOOL)animated{
    [self.lifeTableView.mj_header endRefreshing];
}



#pragma mark - API Request
/**
 *  見守る対象者一覧
 */
-(void)getCustList{

    MCustInfoParam *param = [[MCustInfoParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.hassensordata = @"1";
    
    [MCustTool custInfoWithParam:param success:^(NSArray *array) {
        if (array.count == 0) {
            [MBProgressHUD showError:@"見守り対象者を追加してください"];
            [self.lifeTableView.mj_header endRefreshing];
        }
        if (array.count>0) {
            //保存detailinfo的数组转换成json数据格式
            NSError *parseError = nil;
            NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
            NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            NITLog(@"%@",str);
            
            NSArray *tmpArr = [LifeUserListModel mj_objectArrayWithKeyValuesArray:array];
            self.custArr= tmpArr.count ? [NSMutableArray arrayWithArray:tmpArr] : [NSMutableArray new];
            [self.lifeTableView reloadData];
        }
    } failure:^(NSError *error) {
        NITLog(@"zwgetcustlist请求失败");
        [self.lifeTableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"後ほど試してください"];
    }];
}

#pragma mark - UITableView dataSource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.custArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    LifesTableViewCell *cell = [LifesTableViewCell cellWithTableView:self.lifeTableView];
    
    
    if (self.segmentNum == 0) {
        cell.segmentIndex = 0;
    }else if (self.segmentNum == 1){
        cell.segmentIndex = 1;
    }
    // 2.传递模型
    cell.CellModel = self.custArr[indexPath.row];
    
    // 3.设置代理
    cell.delegate = self;
    [self.lifeTableView.mj_header endRefreshing];
    
    return cell;
}

//tableviewcell点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.deliverModel = self.custArr[indexPath.row];
    
    //介護記録へ遷移
    if (self.segmentNum == 1) {
        [self performSegueWithIdentifier:@"nursingNotesPush" sender:self];
    }
    //グラフへ遷移
    else if (self.segmentNum == 0) {
        [self performSegueWithIdentifier:@"sensorDataPush" sender:self];
    }
}

#pragma mark - LifesTableViewCellDelegate
/**
 *  新規追加ボタンが押された時
 */
-(void)addBtnClicked:(LifesTableViewCell*)lifesCell{
    
    self.deliverModel = lifesCell.CellModel;
    
    [self performSegueWithIdentifier:@"addNursingPush" sender:self];
    
}

#pragma mark - Segmented

//Segmented 选择
- (IBAction)clickSegmented:(UISegmentedControl*)sender {
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        self.segmentNum = 0;
    }else if (self.segmentControl.selectedSegmentIndex == 1){
        self.segmentNum = 1;
    }
    
    [self.lifeTableView reloadData];

}

#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //介護記録へ遷移
    if ([segue.identifier isEqualToString:@"nursingNotesPush"]) {

        NursingNotesTableViewController * vc = segue.destinationViewController;
        vc.dispname = self.deliverModel.dispname;
        vc.userid0 = self.deliverModel.userid0;
    
        
    //グラフへ遷移
    }else if([segue.identifier isEqualToString:@"sensorDataPush"]){
        
        LifeChartController *vc = segue.destinationViewController;
        
        vc.userid0 = self.deliverModel.userid0;
        NSString *tt = [NSString stringWithFormat:@"%@(%@)",self.deliverModel.user0name,self.deliverModel.roomname];
        
        vc.title = tt;
        
        vc.ariresult = self.deliverModel.resultname;
        vc.username = self.deliverModel.user0name;
        vc.roomID = self.deliverModel.roomid;
        vc.picpath = self.deliverModel.picpath;
        
    //介護メモ入力
    }else if([segue.identifier isEqualToString:@"addNursingPush"]){
        
        //添加介护记录
        AddNursingViewController *vc = segue.destinationViewController;
        vc.dispname = self.deliverModel.dispname;
        vc.userid0 = self.deliverModel.userid0;
    }
    
}



@end
