//
//  RoomReportController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/4.
//  Copyright © 2017年 totyu3. All rights reserved.
//  居室場所

#import "RoomReportController.h"
#import "RoomReportCell.h"

@interface RoomReportController ()

@property (strong, nonatomic) IBOutlet UITextField *hostID;

@property (strong, nonatomic) IBOutlet UITextField *facilityName1;

@property (strong, nonatomic) IBOutlet DropButton   *facilityBtn;

@property (strong, nonatomic) IBOutlet UITableView  *tableView;
@property (strong, nonatomic) IBOutlet UIView       *footView;

@property (nonatomic, assign) BOOL                   isEdit;

@property (strong, nonatomic) IBOutlet UIButton     *editButton;

@property (nonatomic, strong) NSMutableArray        *allDatas;

@end

@implementation RoomReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.footView.height = 0;
    self.footView.alpha = 0;
    //    [self.footView setHidden:NO];
    
    NSArray *arr = nil;
    [NITUserDefaults setObject:arr forKey:@"ROOMMASTERINFOKEY"];
    
    //    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getnlInfo)];
    
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    self.isEdit = NO;
    
    //监听键盘出现和消失
    [NITNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [NITNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}

#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, keyBoardRect.size.height -49, 0)];
    
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}

-(void)dealloc {
    
    [NITNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NITNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

//数据请求
- (void)getnlInfo {
    
    NSString *facd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    NSDictionary *dic = @{@"facilitycd":facd};
    
    [MHttpTool postWithURL:NITGetRoomInfo params:dic success:^(id json) {
        
        [self.tableView.mj_header endRefreshing];
        
        NSArray *baseinfos = [json objectForKey:@"baseinfo"];
        
        NSArray *roomlist = [json objectForKey:@"roomlist"];
    
        
        if (baseinfos.count > 0) {
            
            self.hostID.text = [baseinfos.firstObject objectForKey:@"hostcd"];
            
            self.facilityName1.text = [baseinfos.firstObject objectForKey:@"facilityname2"];
            
        }
        
        
        
        if (roomlist.count >0) {
            
            _allDatas = [NSMutableArray arrayWithArray:roomlist.mutableCopy];
            
            [NITUserDefaults setObject:roomlist forKey:@"ROOMMASTERINFOKEY"];
            
        }
        
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        NITLog(@"%@",error);
        
    }];
    
}


- (IBAction)editCell:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"編集"]) {
        [sender setTitle:@"完了" forState:UIControlStateNormal];
        
//        self.numxxid = 0;
        
        self.isEdit = YES;
        [self ViewAnimateStatas:120];
        
        //进入编辑状态
        //        [self.tableView setEditing:YES animated:YES];///////////
    }else{
        
        
        //        [sender setTitle:@"編集" forState:UIControlStateNormal];
        
        [self saveInfo:nil]; //跟新或者追加
        
    }
    
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
    }];
    
}

-(void)ViewAnimateStatas:(double)statas {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.footView.height = statas;
        self.footView.alpha = 1;
    } completion:^(BOOL finished) {
        [CATransaction setCompletionBlock:^{
            [self.tableView reloadData];
        }];
    }];
}

- (IBAction)addCell:(id)sender {
    
//    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"ROOMMASTERINFOKEY"]];
    [arr addObject:@{@"floorno":@"",@"roomcd":@""}];
    [NITUserDefaults setObject:arr forKey:@"ROOMMASTERINFOKEY"];
//
//    self.numxxid++;
    
    
    [CATransaction setCompletionBlock:^{
        
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }];
    
}


- (IBAction)saveInfo:(id)sender {
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    
    NSArray *array = [NITUserDefaults objectForKey:@"ROOMMASTERINFOKEY"];
    
    NSError *parseError = nil;
    
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    NSString *facd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    
    NSDictionary *dic = @{@"roomlist":str,@"facilitycd":facd};
    
    [MHttpTool postWithURL:NITUpdateRoomInfo params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (json) {
            NSString *code = [json objectForKey:@"code"];
            NITLog(@"%@",code);
            [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
            //            [self.tableView setEditing:NO animated:YES];
            self.footView.height = 0;
            self.footView.alpha = 0;
            self.isEdit = NO;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        //        [self.tableView setEditing:NO animated:YES];
        NITLog(@"%@",error);
    }];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = [NITUserDefaults objectForKey:@"ROOMMASTERINFOKEY"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    RoomReportCell
    RoomReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomReportCell" forIndexPath:indexPath];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"ROOMMASTERINFOKEY"]];
    
    cell.editOp = self.isEdit;
    cell.cellindex = indexPath.row;
    NSDictionary *dic = arr[indexPath.row];
    if (dic) {
        cell.datasDic = dic.copy;
    }
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleNone;
}

@end
