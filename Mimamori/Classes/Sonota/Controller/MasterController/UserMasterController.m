//
//  UserMasterController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "UserMasterController.h"
#import "UserMasterCell.h"


@interface UserMasterController ()

@property (strong, nonatomic) IBOutlet UITextField *companyName;

@property (strong, nonatomic) IBOutlet UITextField *facilityName;

@property (strong, nonatomic) IBOutlet DropButton   *facilityBtn;

@property (strong, nonatomic) IBOutlet UITableView  *tableView;
@property (strong, nonatomic) IBOutlet UIView       *footView;

@property (nonatomic, assign) BOOL                   isEdit;
@property (strong, nonatomic) IBOutlet UIButton     *editButton;
@property (nonatomic, strong) NSMutableArray        *allDatas;

@property (nonatomic, strong) NSString              *maxId;
@property (nonatomic, assign) NSInteger             numxxid;

@end

@implementation UserMasterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.footView.height = 0;
    self.footView.alpha = 0;
//    [self.footView setHidden:NO];
    
    NSArray *arr = nil;
    [NITUserDefaults setObject:arr forKey:@"STAFFINFO"];
    
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
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height - 49, 0);
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
    
    [MHttpTool postWithURL:NITGetStaffInfo params:dic success:^(id json) {
        
        [self.tableView.mj_header endRefreshing];
        
        if (json) {
            
            NSArray *stafflist = [json objectForKey:@"stafflist"];
            
            self.maxId = [json objectForKey:@"maxstaffid"];
            
            NSArray *baseinfos = [json objectForKey:@"baseinfo"];
            
            self.companyName.text = [baseinfos.firstObject objectForKey:@"companyname"];
            
            self.facilityName.text = [baseinfos.firstObject objectForKey:@"facilityname2"];
            
            NSArray *btnL = [json objectForKey:@"usertypelist"];
            
            [NITUserDefaults setObject:btnL forKey:@"usertypelist"];
            
            _allDatas = [NSMutableArray arrayWithArray:stafflist.mutableCopy];
            
            [NITUserDefaults setObject:stafflist forKey:@"STAFFINFO"];
            
            [self.tableView reloadData];
            
        } else {
            
            NITLog(@"没数据");
            
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        NITLog(@"%@",error);
        
    }];
    
}


- (IBAction)editCell:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"編集"]) {
        [sender setTitle:@"完了" forState:UIControlStateNormal];
        
        self.numxxid = 0;
        
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
    if ((id)self.maxId != [NSNull null]) {
        NSString *laststr = [self.maxId substringFromIndex:self.maxId.length - 5];
        NSString *fiststr = [self.maxId substringToIndex:self.maxId.length - 5];
        
        NSInteger numId = [laststr integerValue] + self.numxxid;
        
        NSString *staffidstr = [NSString stringWithFormat:@"%@%05i",fiststr,(int)numId];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"STAFFINFO"]];
        [arr addObject:@{@"nickname":@"",@"staffid":staffidstr,@"usertype":@"",@"usertypename":@""}];
        [NITUserDefaults setObject:arr forKey:@"STAFFINFO"];
        
        self.numxxid++;
        
        
        [CATransaction setCompletionBlock:^{
            
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }];
    }else{
        [self getnlInfo];
    }
}


- (IBAction)saveInfo:(id)sender {
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    
    NSArray *array = [NITUserDefaults objectForKey:@"STAFFINFO"];
    
    NSError *parseError = nil;
    
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{@"stafflist":str};
    
    [MHttpTool postWithURL:NITUpdateStaffInfo params:dic success:^(id json) {
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
    
    NSArray *arr = [NITUserDefaults objectForKey:@"STAFFINFO"];
    return arr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserMasterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserMasterCell" forIndexPath:indexPath];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"STAFFINFO"]];
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

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return self.footView;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    return self.footView.height;
//}

@end
