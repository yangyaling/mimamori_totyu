//
//  LifeViewController.m
//  Mimamori
//
//  Created by NISSAY IT on 16/6/7.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "LifeChartController.h"

#import "LifeViewController.h"
#import "LifesTableViewCell.h"
#import "LifeUserListModel.h"

#import "MCustTool.h"

/**
入居者一覧画面のコントローラ
 */
@interface LifeViewController ()<LifesTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl  *segmentControl;

@property (weak, nonatomic) IBOutlet UITableView         *lifeTableView;



/**
  ユーザモデル
 */
@property (nonatomic,strong) LifeUserListModel           *deliverModel;



/**
 すべてのモデルデータ
 */
@property (strong, nonatomic) NSMutableArray             *custArr; //

@property (strong, nonatomic) IBOutlet DropButton        *facilitiesBtn;


@end

@implementation LifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // 空のセルを表示させない
    self.lifeTableView.tableFooterView = [[UIView alloc]init];
    
    self.lifeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCustList)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.lifeTableView.mj_header];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    //更新施設名２
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
    [self.lifeTableView.mj_header beginRefreshing];
}

/**
   切替施設 delegate
 */
-(void)SelectedListName:(NSDictionary *)clickDic; {
    
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
    param.staffid = [NITUserDefaults objectForKey:@"userid1"];
    param.facilitycd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    param.hassensordata = @"1";
    
    [MCustTool custInfoWithParam:param success:^(NSArray *array) {
        [self.lifeTableView.mj_header endRefreshing];
        if (array.count == 0) {
            [MBProgressHUD showError:@"見守り対象者を追加してください"];
            self.custArr = [NSMutableArray new];
        }
        if (array.count>0) {
            
            /*Transform into model*/
            NSArray *tmpArr = [LifeUserListModel mj_objectArrayWithKeyValuesArray:array];
            self.custArr= tmpArr.count ? [NSMutableArray arrayWithArray:tmpArr] : [NSMutableArray new];
            
        }
        [self.lifeTableView reloadData];
    } failure:^(NSError *error) {
        
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
    LifesTableViewCell *cell = [LifesTableViewCell cellWithTableView:self.lifeTableView];
    
    cell.CellModel = self.custArr[indexPath.row];
    
    cell.delegate = self;
    
    return cell;
}

//tableviewcell  
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.deliverModel = self.custArr[indexPath.row];
    
    [self performSegueWithIdentifier:@"sensorDataPush" sender:self];
    
}

#pragma mark - LifesTableViewCellDelegate
/**
 *  新規追加ボタンが押された時
 */
-(void)addBtnClicked:(LifesTableViewCell*)lifesCell{
    
    self.deliverModel = lifesCell.CellModel;
    
    [self performSegueWithIdentifier:@"addNursingPush" sender:self];
    
}

#pragma mark - UIStoryboardSegue

/**
 Push ->   KVC値渡す
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    //グラフへ遷移
    if([segue.identifier isEqualToString:@"sensorDataPush"]){
        
        LifeChartController *vc = segue.destinationViewController;
        
        vc.userid0 = self.deliverModel.userid0;
        
        NSString *tt = [NSString stringWithFormat:@"%@(%@)",self.deliverModel.user0name,self.deliverModel.roomid];
        
        vc.viewTitle = tt;
        
        vc.ariresult = self.deliverModel.resultname;
        vc.username = self.deliverModel.user0name;
        vc.roomID = self.deliverModel.roomid;
        vc.picpath = self.deliverModel.picpath;
        
    }
    
}



@end
