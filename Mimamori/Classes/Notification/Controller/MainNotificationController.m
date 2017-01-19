//
//  MainNotificationController.m
//  Mimamori
//
//  Created by totyu2 on 2016/06/06.
//  Copyright © 2016年 totyu3. All rights reserved.




#import "MainNotificationController.h"

#import "DetailController.h"


#import "NotificationCell.h"

#import "WHUCalendarPopView.h"

#import "NotificationModel.h"

#import "MTitleLabel.h"

#import "MNoticeTool.h"

#import "AriScenarioController.h"

@interface MainNotificationController ()<NotificationCellDelegate,CalendarPopDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, assign) BOOL isCounter;

@property (strong, nonatomic) UITableView *MyTableView;

@property (nonatomic, weak) WHUCalendarPopView *POPCalendar;

@property (nonatomic, weak) MTitleLabel *titleLabel; //タイトル
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentC;

@property (nonatomic, copy) NSString *refreshDate; //最終更新時間(タイトルに表示)

@property (nonatomic, strong) NSMutableArray *noticesArray;//全ての通知アイテム
@property (strong, nonatomic) IBOutlet UIView *contenView;

@property (nonatomic, assign) NSInteger                  segmentindex;

@property (nonatomic, strong) NSArray                    *datelists0;
@property (nonatomic, strong) NSArray                    *datelists1;
@property (nonatomic, strong) NSArray                    *datelists2;
@property (nonatomic, assign) NSInteger                  typenum;

@property (nonatomic, assign) BOOL                       onstauts;

@end

@implementation MainNotificationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.segmentC setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    //ログインFlag -> 0 (ログイン済)
    
    NSString *plistPath = [NITDocumentDirectory stringByAppendingPathComponent:@"loginFlgRecord.plist"];
    NSDictionary *oldKey = @{@"OldloginFlgKey":@"mimamori2"};
    [oldKey writeToFile:plistPath atomically:YES];
    
//    [NITUserDefaults setObject:@"mimamori2" forKey:@"OldloginFlgKey"];
//    [NITUserDefaults synchronize];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addContenViewSubUI];  //添加日历UI
    
    [self CreateTableViewUI];  //创建tableviewUI
    
    // タイトル
    [self setupTitleView];
    
    [self dateList];  //加载日历履历数据
    
    
    self.isCounter = YES; //日历弹出开关
    
    self.segmentindex = 0;   //  选择器1  num
    
    self.typenum = 0; //  选择器2  num
    
    self.onstauts = NO;  //是否是在日历选择了日期
}


/**
  创建tableviewUI
 */
- (void)CreateTableViewUI {
    _MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, NITScreenW, NITScreenH) style:UITableViewStylePlain];
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
//    _MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_MyTableView];
    
    self.MyTableView.tableFooterView = [[UIView alloc]init];

    self.MyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    [NITRefreshInit MJRefreshNormalHeaderInitTwo:(MJRefreshNormalHeader*)self.MyTableView.mj_header];
}




-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.MyTableView.mj_header beginRefreshing];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self.view];
    
    [self.MyTableView.mj_header endRefreshing];
    
}

- (void)setRefreshDate:(NSString *)refreshDate {
    _refreshDate = refreshDate;
    self.titleLabel.text = self.refreshDate;
}



- (IBAction)NoticeSelectSegement:(UISegmentedControl *)sender {
    
    self.segmentindex = sender.selectedSegmentIndex;
    
    if (sender.selectedSegmentIndex == 0){
        [self.MyTableView.mj_header beginRefreshing];
        [self.POPCalendar dismiss];
        [self.contenView setHidden:YES];
        self.MyTableView.frame = CGRectMake(0, 104 , NITScreenW, NITScreenH - 150);
    } else {
        [self.MyTableView.mj_header beginRefreshing];
        [self.contenView setHidden:NO];
        self.MyTableView.frame = CGRectMake(0, 144 , NITScreenW, NITScreenH - 193);
    }
    
    [self.MyTableView reloadData];
}


/**
 选择当前需要的日历数据
 */
- (void)TimeSegmentAction:(UISegmentedControl *)sender {
    
    self.typenum = sender.selectedSegmentIndex;
    
    [self.MyTableView.mj_header beginRefreshing];
    
    
}

#pragma mark  Refresh Action

-(void)pullRefresh{
    
    self.onstauts = NO;  //非日历选择日期状态
    
    [self.POPCalendar removeFromSuperview];   //每次刷新先删除日历
    [MBProgressHUD showMessage:@"" toView:self.view];
    //1. 通知リストを取得
    if (self.segmentindex == 0) {
        
        [self noticeInfoWithDate:[NSDate SharedToday] andHistoryflg:@"0" withNoticetype:@"0"];
      
        
    } else {
        
        [self noticeInfoWithDate:[NSDate SharedToday] andHistoryflg:@"1" withNoticetype:[NSString stringWithFormat:@"%ld",self.typenum]];
    }
}

#pragma mark Setup UI

// タイトルを設定
- (void)setupTitleView {
    MTitleLabel *label = [MTitleLabel titleLabel];
    label.frame = CGRectMake(0, 0, 200, 40);
    self.navigationItem.titleView = label;
    self.titleLabel = label;
}



/**
   初始化日历   根据已有日期每次重新创建
 */
-(void)setupCalendarDates:(NSArray *)array{
    
    WHUCalendarPopView *POPCalendar = [[WHUCalendarPopView alloc] initWithFrame:CGRectMake(0, 136, NITScreenW, NITScreenH - 185) withArray:array];
    
    self.POPCalendar = POPCalendar;
    
    self.POPCalendar.calendarDelegate = self;
    
    [self.view addSubview:self.POPCalendar];
    
    typeof(self) __weak weakSelf = self;
    
    // 选择日期的时候会被调用
    self.POPCalendar.onDateSelectBlk=^(NSDate* date){
        
        NSString *selectedDate = [date needDateStatus:NotHaveType];
        
        if ([NSDate isEarlyThanToday:date] == NO) {
            
            [MBProgressHUD showError:@"過去の時間を選択してください"];
            
        } else {
            
            self.onstauts = YES;
            
            [MBProgressHUD showMessage:@"" toView:self.view];
            
            [weakSelf noticeInfoWithDate:selectedDate andHistoryflg:@"1" withNoticetype:@"0"];
            
        }
        
        weakSelf.isCounter = YES;
        
        NITLog(@"SelectedCalendarDate-----%@",selectedDate);
        
    };
    
}

#pragma mark Calendar

// 点击日历按钮调用
- (void)ShowCalendar:(UIButton *)sender {
    
    if (self.isCounter) {
        
        [self.POPCalendar show];
        
        self.isCounter = NO;
        
    } else {
        
        [self.POPCalendar dismiss];
        
        self.isCounter = YES;
    }
}

/**
 *  点击calendar阴影隐藏calendar
 */
- (void)GetCurrentCanlendarStatus:(BOOL)isShow {
    self.isCounter = YES;
}



#pragma mark - API Request
/**
 *  通知を取得
 */
-(void)noticeInfoWithDate:(NSString *)date andHistoryflg:(NSString *)flg withNoticetype:(NSString *)typenum{
    
    // 请求参数
    MNoticeInfoParam *param = [[MNoticeInfoParam alloc]init];
    
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    
    //除了日历选择的日期外其他参数都为 startdate
    if (self.onstauts) {
        param.selectdate = date;
    } else {
        param.startdate = date;
    }
    
    param.historyflg = flg;
    
    param.noticetype = typenum;
    
    
    [MNoticeTool noticeInfoWithParam:param success:^(NSArray *array) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [self.MyTableView.mj_header endRefreshing];
        self.noticesArray = [NotificationModel mj_objectArrayWithKeyValuesArray:array];
        
        //　最終更新時間を更新
        self.refreshDate = [NSString stringWithFormat:@"%@\n最終更新時間:%@",[NSDate SharedToday],[[NSDate date] needDateStatus:HMSType]];
        
        
        if (array.count == 0) {
            [MBProgressHUD showError:@"通知がありません"];
        }
        
        if (!self.onstauts) {
            if (self.typenum == 0) {
                [self setupCalendarDates:[self.datelists0 copy]];// 创建日历 - 选择日期
                self.isCounter = YES;
            } else if (self.typenum == 1) {
                [self setupCalendarDates:[self.datelists1 copy]];// 创建日历 - 选择日期
                self.isCounter = YES;
            } else {
                [self setupCalendarDates:[self.datelists2 copy]];// 创建日历 - 选择日期
                self.isCounter = YES;
            }
        }
        
        
        [self.MyTableView reloadData];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [self.MyTableView.mj_header endRefreshing];
        
        if (self.typenum == 0) {
            [self setupCalendarDates:[self.datelists0 copy]];// 创建日历 - 选择日期
            self.isCounter = YES;
        } else if (self.typenum == 1) {
            [self setupCalendarDates:[self.datelists1 copy]];// 创建日历 - 选择日期
            self.isCounter = YES;
        } else {
            [self setupCalendarDates:[self.datelists2 copy]];// 创建日历 - 选择日期
            self.isCounter = YES;
        }
        
    }];
    
}




/**
 *  通知のある日付を取得
 */
-(void)dateList{
    
    MNoticeDateParam *param = [[MNoticeDateParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    
    [MNoticeTool noticeDatesWithParam:param success:^(NSDictionary *dic) {
        [self.MyTableView.mj_header beginRefreshing];
        if (dic.count > 0) {
            
            self.datelists0 = dic[@"datelist0"];
            self.datelists1 = dic[@"datelist1"];
            self.datelists2 = dic[@"datelist2"];
            
        } else {
            NITLog(@"日历数据获取失败");
            
        }
    } failure:^(NSError *error) {
        NITLog(@"日历数据获取失败");
        NITLog(@"zwgetnoticedatelist请求失败:%@",error);
        [self.MyTableView.mj_header beginRefreshing];
        //[MBProgressHUD showError:@"後ほど試してください"];
    }];
}


#pragma mark - NotificationCellDelegate
// 確認必要ボタンを押す時
-(void)notificationCellBtnClicked:(NotificationCell *)notificationCell{
    
    MNoticeInfoUpdateParam *param = [[MNoticeInfoUpdateParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    param.noticeid = [NSString stringWithFormat:@"%ld",(long)notificationCell.notice.noticeid];
    param.noticetype = [NSString stringWithFormat:@"%ld",(long)notificationCell.notice.type];
    param.registdate = [[NSDate date]needDateStatus:HaveHMSType];
    param.staupduser = [NITUserDefaults objectForKey:@"userid1"];
    
    [MNoticeTool noticeInfoUpdateWithParam:param success:^(NSString *code) {
        if ([code isEqualToString:@"200"]) {
            [self.MyTableView.mj_header beginRefreshing];
        }
    } failure:^(NSError *error) {
        [self.MyTableView.mj_header beginRefreshing];
    }];
}


#pragma mark - UITableView dataSource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noticesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationCell *cell = [NotificationCell cellWithTableView:tableView];
    
    cell.notice =  self.noticesArray[indexPath.row];
    
    cell.delegate = self;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationModel *model = self.noticesArray[indexPath.row];
    if (model.type == 2) {
        [self performSegueWithIdentifier:@"pushPostC" sender:self];
    } else {
        UIStoryboard *lifeStoryBoard = [UIStoryboard storyboardWithName:@"Life" bundle:nil];
        
        AriScenarioController *secondViewController = [lifeStoryBoard instantiateViewControllerWithIdentifier:@"AriScenarioID"];
        
        secondViewController.usernumber = model.userid1;
        secondViewController.username = model.username;
        secondViewController.isPushOrPop = NO;
        //跳转事件
        [self.navigationController pushViewController:secondViewController animated:YES];

    }
    
}


/**
  添加日历、履历UI
 */
- (void)addContenViewSubUI {
    
    UIButton *CalendarButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 3, 35, 35)];
    [CalendarButton setTitleColor:NITColor(252, 85, 115) forState:UIControlStateNormal];
    
    [CalendarButton setImage:[UIImage imageNamed:@"Calendar"] forState:UIControlStateNormal];
    
    UISegmentedControl *timeSegement = [[UISegmentedControl alloc] initWithItems:@[@"全て",@"アラート",@"支援"]];
    
    timeSegement.tintColor = NITColor(252, 55, 95);
    
    timeSegement.selectedSegmentIndex = 0;
    
    timeSegement.frame = CGRectMake(65, 5, (self.view.width - 60) * 0.9, 30);
    
    [timeSegement setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    
    [CalendarButton addTarget:self action:@selector(ShowCalendar:) forControlEvents:UIControlEventTouchUpInside];
    
    [timeSegement addTarget:self action:@selector(TimeSegmentAction:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.contenView addSubview:CalendarButton];
    
    [self.contenView addSubview:timeSegement];
    
    [self.contenView setHidden:YES];
}



#pragma mark - Other

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"pushPostC"]) {
        
        NSIndexPath *indexPath = self.MyTableView.indexPathForSelectedRow;
        
        NotificationModel *model = self.noticesArray[indexPath.row];
        
        DetailController *dlc = segue.destinationViewController;
        
        dlc.titles = [NSString stringWithFormat:@"<支援要請>%@",model.username];
        
        dlc.address = model.title;
        
        dlc.putdate = model.registdate;
        
        dlc.contents = model.content;
        
    }
}


@end
