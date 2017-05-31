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

//#import "MTitleLabel.h"

#import "MNoticeTool.h"

#import "AriScenarioController.h"

#import "AppDelegate.h"

@interface MainNotificationController ()<NotificationCellDelegate,CalendarPopDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, assign) BOOL                       isCounter;

@property (strong, nonatomic) UITableView                *MyTableView;

@property (nonatomic, weak) WHUCalendarPopView           *POPCalendar;

@property (strong, nonatomic) IBOutlet UILabel           *titleLabel;


@property (strong, nonatomic) IBOutlet UISegmentedControl*segmentC;

@property (nonatomic, copy) NSString                     *refreshDate; //最終更新時間(タイトルに表示)

@property (nonatomic, strong) NSMutableArray             *noticesArray;//全ての通知アイテム
@property (strong, nonatomic) IBOutlet UIView            *contenView;

@property (nonatomic, assign) NSInteger                  segmentindex;

@property (nonatomic, strong) NSArray                    *datelists0;
@property (nonatomic, strong) NSArray                    *datelists1;
@property (nonatomic, strong) NSArray                    *datelists2;
@property (nonatomic, assign) NSInteger                  typenum;

@property (nonatomic, assign) BOOL                       onstauts;


@property (strong, nonatomic) IBOutlet DropButton        *facilitiesBtn;


@end

@implementation MainNotificationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.segmentC setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate startTimer];
    //ログインFlag -> 0 (ログイン済)
    
    NSString *plistPath = [NITDocumentDirectory stringByAppendingPathComponent:@"loginFlgRecord.plist"];
    
    NSDictionary *oldKey = @{@"OldloginFlgKey":@"mimamori2"};
    
    [oldKey writeToFile:plistPath atomically:YES];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addContenViewSubUI];  //添加日历UI
    
    [self CreateTableViewUI];  //创建tableviewUI
    
    
    self.isCounter = YES; //日历弹出开关
    
    self.segmentindex = 0;   //  选择器1  num
    
    self.typenum = 1; //  选择器2  num
    
    self.onstauts = NO;  //是否是在日历选择了日期
    
    
}



/**
 创建tableviewUI
 */
- (void)CreateTableViewUI {
    _MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 139 , NITScreenW, NITScreenH - 185) style:UITableViewStylePlain];
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
    //    _MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_MyTableView];
    
    self.MyTableView.tableFooterView = [[UIView alloc]init];
    
    self.MyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    [NITRefreshInit MJRefreshNormalHeaderInitTwo:(MJRefreshNormalHeader*)self.MyTableView.mj_header];
    
    
}


-(void)SelectedListName:(NSString *)clickName {
    
    [self dateList]; //日历数据
    
    UIButton *btn  = (UIButton *)[self.view viewWithTag:888888];
    
    btn.backgroundColor = [UIColor whiteColor];
    
    [btn setTitleColor:NITColor(252, 85, 115) forState:UIControlStateNormal];
    
    
    UIButton *oldbtn = (UIButton *)[self.view viewWithTag:666666];
    
    oldbtn.backgroundColor = NITColor(252, 85, 115);
    
    [oldbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.POPCalendar dismiss];
    
    self.isCounter = YES;
    
    NITLog(@"32131232131321ononono");
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self dateList]; //日历数据
    
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
    
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
        self.MyTableView.frame = CGRectMake(0, 139 , NITScreenW, NITScreenH - 185);
    } else {
        [self.MyTableView.mj_header beginRefreshing];
        [self.contenView setHidden:NO];
        self.MyTableView.frame = CGRectMake(0, 179 , NITScreenW, NITScreenH - 228);
        
        //交换背景颜色
        [self selectButtonViewTag:6];
        [self selectButtonViewTag:8];
        
    }
    
    [self.MyTableView reloadData];
}


/**
 选择当前需要的日历数据
 */
- (void)oldBtnAction:(UIButton *)sender {
    sender.backgroundColor = NITColor(252, 85, 115);
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setEnabled:NO];
    
    [self selectButtonViewTag:8];
    self.typenum = 1;
    self.onstauts = NO;
    
    [self.MyTableView.mj_header beginRefreshing];
    
}

-(void)selectButtonViewTag:(int)tag{
    if (tag == 6) {
        
        UIButton *oldbtn = (UIButton *)[self.view viewWithTag:666666];
        
        oldbtn.backgroundColor = NITColor(252, 85, 115);
        
        [oldbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    } else {
        
        UIButton *btn  = (UIButton *)[self.view viewWithTag:888888];
        
        btn.backgroundColor = [UIColor whiteColor];
        
        [btn setTitleColor:NITColor(252, 85, 115) forState:UIControlStateNormal];
    }
    
}

#pragma mark  Refresh Action

-(void)pullRefresh{
    
    self.onstauts = NO;  //非日历选择日期状态
    
    [self.POPCalendar removeFromSuperview];   //每次刷新先删除日历
//    [MBProgressHUD showMessage:@"" toView:self.view];
    //1. 通知リストを取得
    if (self.segmentindex == 0) {
        
        [self noticeInfoWithDate:[NSDate SharedToday] andHistoryflg:@"0" withNoticetype:@"0"];
        
        
    } else {
        
        [self noticeInfoWithDate:[NSDate SharedToday] andHistoryflg:[NSString stringWithFormat:@"%ld",self.typenum]withNoticetype:@"0"];
    }
}

#pragma mark Setup UI




/**
 初始化日历   根据已有日期每次重新创建
 */
-(void)setupCalendarDates:(NSArray *)array{
    
    WHUCalendarPopView *POPCalendar = [[WHUCalendarPopView alloc] initWithFrame:CGRectMake(0, 171, NITScreenW, NITScreenH - 220) withArray:array];
    
    self.POPCalendar = POPCalendar;
    
    self.POPCalendar.calendarDelegate = self;
    
    [self.view addSubview:self.POPCalendar];
    
    typeof(self) __weak weakSelf = self;
    
    // 选择日期的时候会被调用
    self.POPCalendar.onDateSelectBlk=^(NSDate* date){
        [self selectButtonViewTag:8];
        
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
        sender.backgroundColor = NITColor(252, 85, 115);
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:666666];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:NITColor(252, 85, 115) forState:UIControlStateNormal];
        [btn setEnabled:YES];
        [self.POPCalendar show];
        
        self.isCounter = NO;
        
    } else {
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setTitleColor:NITColor(252, 85, 115) forState:UIControlStateNormal];
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
    
    param.staffid = [NITUserDefaults objectForKey:@"userid1"];
    
    param.facilitycd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    
    //除了日历选择的日期外其他参数都为 startdate
    if (self.onstauts) {
        param.selectdate = date;
    } else {
        param.startdate = date;
    }
    
    param.historyflg = flg;
    
    param.noticetype = @"1";
    
    
    [MNoticeTool noticeInfoWithParam:param success:^(NSArray *array) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [self.MyTableView.mj_header endRefreshing];
        self.noticesArray = [NSMutableArray new];
        self.noticesArray = [NotificationModel mj_objectArrayWithKeyValuesArray:array];
        
        //系统时间 - 12/24 时制  判断
        
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
                [self setupCalendarDates:[self.datelists1 copy]];
                self.isCounter = YES;
            } else {
                [self setupCalendarDates:[self.datelists2 copy]];
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
    
    param.staffid = [NITUserDefaults objectForKey:@"userid1"];
    
    param.facilitycd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    
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
        [secondViewController.navigationItem setHidesBackButton:YES];
        secondViewController.usernumber = model.staffid;
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
    
    UIButton *oldBtn = [[UIButton alloc] initWithFrame:CGRectMake(NITScreenW/2 -150, 3, 150, 30)];
    oldBtn.layer.borderWidth = 1;
    oldBtn.layer.borderColor = NITColor(252, 85, 115).CGColor;
    oldBtn.layer.cornerRadius = 6;
    oldBtn.tag = 666666;
    oldBtn.backgroundColor = NITColor(252, 85, 115);
    oldBtn.enabled = NO;
    [oldBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [oldBtn setTitle:@"直近1ヶ月" forState:UIControlStateNormal];
    
    
    UIButton *CalendarButton = [[UIButton alloc] initWithFrame:CGRectMake(NITScreenW/2 +1, 3, 150, 30)];
    [CalendarButton setTitleColor:NITColor(252, 85, 115) forState:UIControlStateNormal];
    [CalendarButton setTitle:@"カレンダー" forState:UIControlStateNormal];
    CalendarButton.tag = 888888;
    CalendarButton.layer.borderWidth = 1;
    CalendarButton.layer.borderColor = NITColor(252, 85, 115).CGColor;
    CalendarButton.layer.cornerRadius = 6;
    CalendarButton.backgroundColor = [UIColor whiteColor];
    
    [oldBtn addTarget:self action:@selector(oldBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [CalendarButton addTarget:self action:@selector(ShowCalendar:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.contenView addSubview:CalendarButton];
    [self.contenView addSubview:oldBtn];
    
    [self.contenView setHidden:YES];
}



#pragma mark - Other

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    
//    if ([segue.identifier isEqualToString:@"pushPostC"]) {
//        
//        NSIndexPath *indexPath = self.MyTableView.indexPathForSelectedRow;
//        
//        NotificationModel *model = self.noticesArray[indexPath.row];
//        
//        DetailController *dlc = segue.destinationViewController;
//        
//        dlc.titles = [NSString stringWithFormat:@"<支援要請>%@",model.username];
//        
//        dlc.address = model.title;
//        
//        dlc.putdate = model.registdate;
//        
//        dlc.contents = model.content;
//        
//    }
//}


@end
