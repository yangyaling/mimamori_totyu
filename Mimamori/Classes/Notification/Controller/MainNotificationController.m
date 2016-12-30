//
//  MainNotificationController.m
//  Mimamori
//
//  Created by totyu2 on 2016/06/06.
//  Copyright © 2016年 totyu3. All rights reserved.




#import "MainNotificationController.h"
#import "PostLetterController.h"
#import "NotificationCell.h"
#import "WHUCalendarPopView.h"
#import "NotificationModel.h"

#import "MTitleLabel.h"
#import "MNoticeTool.h"

@interface MainNotificationController ()<NotificationCellDelegate,CalendarPopDelegate>


@property (nonatomic, assign) BOOL isCounter;

@property (strong, nonatomic) IBOutlet UITableView *MyTableView;

@property (nonatomic, weak) WHUCalendarPopView *POPCalendar;

@property (nonatomic, weak) MTitleLabel *titleLabel; //タイトル
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentC;

@property (nonatomic, copy) NSString *refreshDate; //最終更新時間(タイトルに表示)

@property (nonatomic, strong) NSMutableArray *noticesArray;//全ての通知アイテム

@property (nonatomic, assign) NSInteger CalendarH;


@end

@implementation MainNotificationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.segmentC setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    
    self.isCounter = YES; //日历弹出开关
    
    //ログインFlag -> 0 (ログイン済)
    [NITUserDefaults setObject:@"0" forKey:@"loginFlg"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;   //tabelView 自适应
    self.MyTableView.tableFooterView = [[UIView alloc]init];
    
    self.MyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    
    // タイトル
    [self setupTitleView];
    
    
    self.CalendarH = 0;
    
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
    
    if (sender.selectedSegmentIndex == 0){
        self.CalendarH = 0;
    } else {
        self.CalendarH = 40;
    }
    
    [self.MyTableView reloadData];
}


#pragma mark  Refresh Action

-(void)pullRefresh{
    //1. 通知リストを取得
    [self noticeInfoWithDateType:TodayDateType date:[NSDate SharedToday]];
    //2. 通知のある日付を取得
    
    [self.POPCalendar removeFromSuperview];
    [self dateList];
}

#pragma mark Setup UI

// タイトルを設定
- (void)setupTitleView {
    MTitleLabel *label = [MTitleLabel titleLabel];
    label.frame = CGRectMake(0, 0, 200, 40);
    self.navigationItem.titleView = label;
    self.titleLabel = label;
}


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
            
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            [weakSelf noticeInfoWithDateType:SelectDateType date:selectedDate];
            
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
-(void)noticeInfoWithDateType:(DateType)type date:(NSString *)date{
    
    // 请求参数
    MNoticeInfoParam *param = [[MNoticeInfoParam alloc]init];
    
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    
    // 選択日の通知リスト
    if (type ==  SelectDateType) {
        
        param.selectdate = date;
        // 直近２日の通知リスト(デフォルト)
        
    } else {
        
        param.startdate = [NSDate SharedToday];
        
    }
    
    [MNoticeTool noticeInfoWithParam:param success:^(NSArray *array) {
        
        self.noticesArray = [NotificationModel mj_objectArrayWithKeyValuesArray:array];
        
        //　最終更新時間を更新
        self.refreshDate = [NSString stringWithFormat:@"%@\n最終更新時間:%@",[NSDate SharedToday],[[NSDate date] needDateStatus:HMSType]];
        
        [self.MyTableView.mj_header endRefreshing];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        if (array.count == 0) {
            
            [MBProgressHUD showError:@"通知がありません"];
        }
        
        [self.MyTableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.MyTableView.mj_header endRefreshing];
        
    }];
    
}



/**
 *  通知のある日付を取得
 */
-(void)dateList{
    
    MNoticeDateParam *param = [[MNoticeDateParam alloc]init];
    param.userid1 = [NITUserDefaults objectForKey:@"userid1"];
    
    [MNoticeTool noticeDatesWithParam:param success:^(NSArray *array) {
        if (array.count > 0) {
//            [NITUserDefaults setObject:[array copy] forKey:@"noticeCalendar"];
//            [NITUserDefaults synchronize];
            
            [self setupCalendarDates:[array copy]];// 创建日历 - 选择日期
            [self.POPCalendar dismiss];
            self.isCounter = YES;
        }
    } failure:^(NSError *error) {
        NITLog(@"zwgetnoticedatelist请求失败:%@",error);
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
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.CalendarH;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    
    UIButton *CalendarButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 3, 35, 35)];
    
    //    UIImageView *imgV = [[UIImageView alloc] init];
    //
    //    imgV.image = ;
    
    //    CalendarButton.backgroundColor = [UIColor redColor];
    [CalendarButton setImage:[UIImage imageNamed:@"Calendar"] forState:UIControlStateNormal];
    
    UISegmentedControl *timeSegement = [[UISegmentedControl alloc] initWithItems:@[@"全て",@"アラート",@"支援"]];
    
    timeSegement.tintColor = NITColor(123, 182, 254);
    
    timeSegement.selectedSegmentIndex = 0;
    
    timeSegement.frame = CGRectMake(65, 5, (self.view.width - 60) * 0.9, 30);
    
//    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
//                                                           forKey:UITextAttributeFont];
//    [timeSegement setTitleTextAttributes:attributes
//                                forState:UIControlStateNormal];
    
    [timeSegement setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont fontWithName:@"SnellRoundhand-Bold" size:24],UITextAttributeFont ,nil];
    
//    [timeSegement setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [CalendarButton addTarget:self action:@selector(ShowCalendar:) forControlEvents:UIControlEventTouchUpInside];
    
    [timeSegement addTarget:self action:@selector(TimeSegmentAction:) forControlEvents:UIControlEventValueChanged];
    
    //    timeSegement.backgroundColor = [UIColor blackColor];
    
    [bgview addSubview:CalendarButton];
    
    [bgview addSubview:timeSegement];
    
    return bgview;
}







- (void)TimeSegmentAction:(UISegmentedControl *)sender {
    
    
}



#pragma mark - Other

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushPostC"]) {
        
        NSIndexPath *indexPath = self.MyTableView.indexPathForSelectedRow;
        
        NotificationModel *model = self.noticesArray[indexPath.row];
        
        PostLetterController *plc = segue.destinationViewController;
        plc.isDetailView = YES;
        plc.contentS = model.content;
        plc.titleS = model.title;
        plc.groupid = [model.groupid intValue] - 1;
        plc.groupName = model.groupname;
    }
}

/**
 *  remove通知
 */
- (void)dealloc {
//    [NITNotificationCenter removeObserver:self name:@"HideCalendar" object:nil];
}


@end
