//
//  NursingNotesTableViewController.m
//  Mimamori
//
//  Created by totyu3 on 16/6/8.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "NursingNotesTableViewController.h"
#import "NursingNotesTableViewCell.h"
#import "VoiceRecognitionController.h"

#import "WHUCalendarPopView.h"
#import "NursingNotesModel.h"


typedef enum {
    
    TodayDateType,
    SelectDateType
}ParametersType;

@interface NursingNotesTableViewController ()<CalendarPopDelegate>

/**
 *  介护纪录 table
 */
@property (weak, nonatomic) IBOutlet UITableView *nursingNotesTable;
/**
 *  名字标题
 */
@property (weak, nonatomic) IBOutlet UILabel *nursingNameLabel;
/**
 *  指定日に介護メモがある全ての日付
 */
@property (strong,nonatomic) NSMutableArray *allDataArray;

@property (strong,nonatomic) NSMutableDictionary *allDataDict;


@property (nonatomic, strong) WHUCalendarPopView                  *POPCalendar;

@property (nonatomic, assign) BOOL                                 isCounter;


@property (nonatomic,strong) AFHTTPSessionManager      *session;


@end

@implementation NursingNotesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化session对象
    _session = [AFHTTPSessionManager manager];
    // 设置请求接口回来时支持什么类型的数组
    _session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];

    
    self.isCounter = YES; //日历弹出开关
        
    
    [self getDatesForCalendar];
    
    self.nursingNotesTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.nursingNotesTable.mj_header];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" 生活" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButtonItem)];
    
//    [NITNotificationCenter addObserver:self selector:@selector(TapHideCalendar) name:@"HideCalendar" object:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.nursingNameLabel.text = self.dispname;
    
    [self pullRefresh];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.nursingNotesTable.mj_header endRefreshing];
}

/**
 *  点击calendar阴影隐藏calendar
 */
- (void)GetCurrentCanlendarStatus:(BOOL)isShow
{
    self.isCounter = YES;
}


/**
 *  プルでリフレッシュ
 */
-(void)pullRefresh{
    [self loadNewDataWithType:TodayDateType andDate:[NSDate SharedToday]];
//    [self.POPCalendar removeFromSuperview];
    
}

-(void)getDatesForCalendar{
    NSString *url = NITGetCarememoDateList;
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setValue:self.userid0 forKey:@"userid0"];
    
    [self.session POST:url parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *dateArr = [responseObject objectForKey:@"datelist"];
        if (dateArr) {
            
            [self setupCalendarDates:[dateArr copy]];// 创建日历 - 选择日期'
//            [self.POPCalendar dismiss];
//            self.isCounter = YES;
        }
        
        [self.nursingNotesTable.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.nursingNotesTable.mj_header endRefreshing];
    }];
}


/**
 *  zwgetcarememoinfo
 *
 *  @param type 今日/選択日付
 */
- (void)loadNewDataWithType:(ParametersType)type andDate:(NSString *)date{
    NSString *url = NITGetCarememoInfo;
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setValue:self.userid0 forKey:@"userid0"];
    if (type == SelectDateType) {
        [parametersDict setValue:date forKey:@"selectdate"];
    }else if (type == TodayDateType){
        [parametersDict setValue:date forKey:@"startdate"];
    }
    [self.session POST:url parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *memos = [responseObject objectForKey:@"carememos"];
        if (memos) {
            self.allDataDict = memos.count>0 ? [NSMutableDictionary dictionaryWithDictionary:memos] : [NSMutableDictionary new];
            
            self.allDataArray = memos.count>0 ?  [NSMutableArray arrayWithArray:[memos allKeys]] : [NSMutableArray new];
            
            [self.nursingNotesTable reloadData];
        }
        [self.nursingNotesTable.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.nursingNotesTable.mj_header endRefreshing];
        [MBProgressHUD showError:@"後ほど試してください"];
    }];
}


/**
 *  获取选择的日期
 */
- (void)setupCalendarDates:(NSArray *)array
{
    
    self.POPCalendar = [[WHUCalendarPopView alloc] initWithFrame:CGRectMake(0, 95, NITScreenW, NITScreenH - 155) withArray:array];
    self.POPCalendar.calendarDelegate = self;
    [self.view addSubview:self.POPCalendar];
    typeof(self) __weak weakSelf = self;
    self.POPCalendar.onDateSelectBlk=^(NSDate* date){
        
        NSString *dateString = [date needDateStatus:NotHaveType];
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"yyyy/MM/dd"];
        NSDate *getdate = [fmt dateFromString:dateString];
        double timesStart = [getdate timeIntervalSince1970]*1000;
        double timesEnd = [[NSDate new] timeIntervalSince1970]*1000;
        if (timesStart > timesEnd) {
            [MBProgressHUD showError:@"過去の時間を選択してください"];
        } else {
            [weakSelf loadNewDataWithType:SelectDateType andDate:dateString];
        }
        weakSelf.isCounter = YES;
        
        NITLog(@"SelectCalendarDate-----%@",dateString);
    };
}

-(void)clickLeftBarButtonItem{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Table view data source and delegate

//返回 Sections 数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.allDataArray.count;
}

//返回 cell 数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray * sectionArr = [self.allDataDict objectForKey:self.allDataArray[section]];
    
    return sectionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    NursingNotesTableViewCell *cell = [NursingNotesTableViewCell cellWithTableView:self.nursingNotesTable];
    
    NSArray * sectionArr = [self.allDataDict objectForKey:self.allDataArray[indexPath.section]];
    
    NSArray *tmpArr = [NursingNotesModel mj_objectArrayWithKeyValuesArray:sectionArr];
    
    // 2.传递模型
    cell.CellModel = tmpArr[indexPath.row];
    
    return cell;
    
}

//自定义 Sections
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]init];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.nursingNotesTable.width, 30)];
    
    titleLabel.text = self.allDataArray[section];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    bgView.backgroundColor = NITColor(252, 85, 115);
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}



//日历选择按钮
- (IBAction)calendar:(id)sender {
    
    if (self.isCounter) {
//        [NITNotificationCenter postNotificationName:@"lifeCalendar" object:nil];
        [self.POPCalendar show];
        self.isCounter = NO;
    } else {
        [self.POPCalendar dismiss];
        self.isCounter = YES;
    }
    
}

//新規追加ボタンを押す

- (IBAction)addNursingButton:(id)sender
{
    [self performSegueWithIdentifier:@"addNursingPushTwo" sender:self];
}


//segue跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addNursingPushTwo"]) {
        
        VoiceRecognitionController * vc = segue.destinationViewController;
        vc.dispname =  self.dispname;
        vc.userid0 = self.userid0;
    }
}

//- (void)dealloc {
//    [NITNotificationCenter removeObserver:self name:@"HideCalendar" object:nil];
//}

@end
