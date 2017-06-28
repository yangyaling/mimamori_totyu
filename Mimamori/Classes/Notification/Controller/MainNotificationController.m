//
//  MainNotificationController.m
//  Mimamori
//
//  Created by NISSAY IT on 2016/06/06.
//  Copyright © 2016年 NISSAY IT. All rights reserved.

#import "MainNotificationController.h"

#import "NotificationCell.h"

#import "WHUCalendarPopView.h"

#import "NotificationModel.h"

//#import "MTitleLabel.h"

#import "MNoticeTool.h"

#import "AriScenarioController.h"

#import "AppDelegate.h"

/**
 Main 通知画面
 */
@interface MainNotificationController ()<NotificationCellDelegate,CalendarPopDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, assign) BOOL                       isCounter;        //カレンダー状態

@property (strong, nonatomic) UITableView                *MyTableView;

@property (nonatomic, weak) WHUCalendarPopView           *POPCalendar;     //カレンダー

@property (strong, nonatomic) IBOutlet UILabel           *titleLabel;


@property (strong, nonatomic) IBOutlet UISegmentedControl*segmentC;

@property (nonatomic, copy) NSString                     *refreshDate; //最終更新時間(タイトルに表示)

@property (nonatomic, strong) NSMutableArray             *noticesArray;//全ての通知アイテム

@property (strong, nonatomic) IBOutlet UIView            *contenView;

@property (nonatomic, assign) NSInteger                  segmentindex;



/**
カレンダーデータ
 */
@property (nonatomic, strong) NSArray                    *datelists0;
@property (nonatomic, strong) NSArray                    *datelists1;
@property (nonatomic, strong) NSArray                    *datelists2;


@property (nonatomic, assign) NSInteger                  typenum;  //一覧状態 ~ 履歴状態

@property (nonatomic, assign) BOOL                       onstauts; //カレンダー状態をクリックして


@property (strong, nonatomic) IBOutlet DropButton        *facilitiesBtn;   //施設ボタン


@end

@implementation MainNotificationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // SegmentedControlのフォントを設定
    [self.segmentC setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    
    //タイマー   スタート
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate startTimer];
    
    
    //ログインFlag -> 0 (ログイン済)
    NSString *plistPath = [NITDocumentDirectory stringByAppendingPathComponent:@"loginFlgRecord.plist"];
    NSDictionary *oldKey = @{@"OldloginFlgKey":@"mimamori2"};
    [oldKey writeToFile:plistPath atomically:YES];
    
    
    [self addContenViewSubUI];  //Init  button
    
    [self CreateTableViewUI];  //Init  tableview
    
    
    self.isCounter = YES;
    
    self.segmentindex = 0;
    
    self.typenum = 1;
    
    self.onstauts = NO;
}



/**
 tableviewUI
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


/**
 施設 delegate
 */
-(void)SelectedListName:(NSString *)clickName {
    
    [self dateList]; //更新カレンダー
    
    //カレンダーボタン
    UIButton *btn  = (UIButton *)[self.view viewWithTag:888888];
    
    btn.backgroundColor = [UIColor whiteColor];
    
    [btn setTitleColor:NITColor(252, 85, 115) forState:UIControlStateNormal];
    
    //直近1ヶ月ボタン
    UIButton *oldbtn = (UIButton *)[self.view viewWithTag:666666];
    
    oldbtn.backgroundColor = NITColor(252, 85, 115);
    
    [oldbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    //カレンダーを隠す
    [self.POPCalendar dismiss];
    
    
    self.isCounter = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self dateList]; //日历数据
    
    
    //更新施設名２
    _facilitiesBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self.view];
    
    [self.MyTableView.mj_header endRefreshing]; //
    
}

- (void)setRefreshDate:(NSString *)refreshDate {
    
    _refreshDate = refreshDate;
    
    self.titleLabel.text = self.refreshDate; //
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
        
        //直近1ヶ月ボタン -> 選択状態
        [self selectButtonViewTag:6];
        //カレンダーボタン -> 選択状態
        [self selectButtonViewTag:8];
    }
    
    [self.MyTableView reloadData];
}


/**
 カレンダーボタン       押す
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



/**
ボタン -> 選択状態
 */
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
    
    self.onstauts = NO;
    
    [self.POPCalendar removeFromSuperview];
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
 カレンダーを初期化
 */
-(void)setupCalendarDates:(NSArray *)array{
    
    WHUCalendarPopView *POPCalendar = [[WHUCalendarPopView alloc] initWithFrame:CGRectMake(0, 171, NITScreenW, NITScreenH - 220) withArray:array];
    
    self.POPCalendar = POPCalendar;
    
    self.POPCalendar.calendarDelegate = self;
    
    [self.view addSubview:self.POPCalendar];
    
    typeof(self) __weak weakSelf = self;
    
    // 選択の日付をフィボナッチリトレースメントする
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

/**
カレンダー  delegate
 */
- (void)GetCurrentCanlendarStatus:(BOOL)isShow {
    self.isCounter = YES;
}

/**
 カレンダー  -> 表示/非表示

 */
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


#pragma mark - API Request
/**
 *  通知を取得
 */
-(void)noticeInfoWithDate:(NSString *)date andHistoryflg:(NSString *)flg withNoticetype:(NSString *)typenum{
    
   
    MNoticeInfoParam *param = [[MNoticeInfoParam alloc]init];
    
    param.staffid = [NITUserDefaults objectForKey:@"userid1"];
    
    param.facilitycd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    
 
    if (self.onstauts) {
        param.selectdate = date;
    } else {
        param.startdate = date;
    }
    
    param.historyflg = flg;
    
    param.noticetype = @"1";
    
    //POST -> 通知一覧データ
    [MNoticeTool noticeInfoWithParam:param success:^(NSArray *array) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [self.MyTableView.mj_header endRefreshing];
        self.noticesArray = [NSMutableArray new];
        
        
        self.noticesArray = [NotificationModel mj_objectArrayWithKeyValuesArray:array];
        
        //　最終更新時間を更新
        self.refreshDate = [NSString stringWithFormat:@"%@\n最終更新時間:%@",[NSDate SharedToday],[[NSDate date] needDateStatus:HMSType]];
        
        
        if (array.count == 0) {
            [MBProgressHUD showError:@"通知がありません"];
        }
        
        if (!self.onstauts) {
            if (self.typenum == 0) {
                [self setupCalendarDates:[self.datelists0 copy]];//
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
            [self setupCalendarDates:[self.datelists0 copy]];//
            self.isCounter = YES;
        } else if (self.typenum == 1) {
            [self setupCalendarDates:[self.datelists1 copy]];//
            self.isCounter = YES;
        } else {
            [self setupCalendarDates:[self.datelists2 copy]];//
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
            
        }
    } failure:^(NSError *error) {
        [self.MyTableView.mj_header beginRefreshing];
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

//push  ->　アラート詳細
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationModel *model = self.noticesArray[indexPath.row];
    
    UIStoryboard *lifeStoryBoard = [UIStoryboard storyboardWithName:@"Life" bundle:nil];
    
    AriScenarioController *secondViewController = [lifeStoryBoard instantiateViewControllerWithIdentifier:@"AriScenarioID"];
    
    [secondViewController.navigationItem setHidesBackButton:YES];
    
    secondViewController.usernumber = model.staffid;
    
    secondViewController.username = model.username;
    
    secondViewController.subtitle = model.subtitle;
    
    secondViewController.isPushOrPop = NO;
    
    [self.navigationController pushViewController:secondViewController animated:YES];
   
}

/**
  Init  直近1ヶ月ボタン ~ カレンダーボタン
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

@end
