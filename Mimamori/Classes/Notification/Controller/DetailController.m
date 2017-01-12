//
//  DetailController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/1/4.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "DetailController.h"

#import "NotificationModel.h"
#import "MNoticeTool.h"

#import "DetailCCell.h"


@interface DetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UILabel *roomID;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;

@property (strong, nonatomic) UITableView      *MyTableView;

@property (nonatomic, strong) NSMutableArray                    *alldatas;

@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isanauto) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.username removeFromSuperview];
        [self.roomID removeFromSuperview];
        [self.time removeFromSuperview];
        [self.textView removeFromSuperview];
        
        [self CreateTableViewUI];
//        [self.pushButton setHidden:NO];
    } else {
        self.pushButton.layer.cornerRadius = 6;
        self.textView.layer.cornerRadius = 6;
        self.textView.layer.borderWidth = 2.5;
        self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //    self.textView.userInteractionEnabled = NO;
        self.textView.editable = NO;
        [self.pushButton setHidden:YES];
        self.username.text = self.titles;
        self.roomID.text = self.address;
        self.time.text = self.putdate;
        self.textView.text = self.contents;
    }
}


/**
 创建tableviewUI
 */
- (void)CreateTableViewUI {
    _MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, NITScreenW, NITScreenH - 113) style:UITableViewStylePlain];
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
    _MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _MyTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_MyTableView];
    
    self.MyTableView.tableFooterView = [[UIView alloc]init];
    
    self.MyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(detailRefresh)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.MyTableView.mj_header];
    
    self.MyTableView.tableFooterView = self.pushButton;
}

- (void)detailRefresh {
    // 请求参数
    MNoticeInfoParam *param = [[MNoticeInfoParam alloc]init];
    
    param.userid1 = [NSString stringWithFormat:@"%ld",self.usernumber];
    
    param.noticetype = [NSString stringWithFormat:@"%ld",self.type];
    
    
    [MNoticeTool noticeInfoWithParam:param success:^(NSArray *array) {
        [self.MyTableView.mj_header endRefreshing];
        if (array.count >0) {
            self.alldatas = [NSMutableArray arrayWithArray:array];
        } else {
            NITLog(@"aratoinfo请求失败");
        }
        
        [self.MyTableView reloadData];
        
    } failure:^(NSError *error) {
        NITLog(@"aratoinfo请求失败:%@",[error localizedDescription]);
        [self.MyTableView.mj_header endRefreshing];
        
    
    }];
    
}


#pragma mark - UITableView dataSource and delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alldatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailCCell *cell = [DetailCCell cellWithTableView:tableView];
    
    NSDictionary *dic = self.alldatas[indexPath.row];
    
    cell.devicename.text = dic[@"devicename"];
    
    NSString *stringtime = [NSString stringWithFormat:@"%@%@",dic[@"time"],dic[@"timeunit"]];
    
    cell.timeValue.text = stringtime;
    
    NSString *stringR = [NSString stringWithFormat:@"%@%@%@",dic[@"value"],dic[@"valueunit"],dic[@"rpoint"]];
    
    cell.valueRp.text = stringR;
                        
    return 0;
    
}


//自定义 SectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, NITScreenW,65)];
    
    UILabel *labelname = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 300, 25)];
    UILabel *labelscenario = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 300, 25)];
    UILabel *labeltime = [[UILabel alloc] initWithFrame:CGRectMake(NITScreenW - 135, 35, 120, 25)];
    
    labeltime.textAlignment = NSTextAlignmentRight;
    
    labelname.text = @"<アラート>入居者名";
    
    labelscenario.text = @"热中症";
    
    labeltime.text = @"2022-24-55 24-58-55";
    
    [titleView addSubview:labelname];
    [titleView addSubview:labelscenario];
    [titleView addSubview:labeltime];
    
    return titleView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
