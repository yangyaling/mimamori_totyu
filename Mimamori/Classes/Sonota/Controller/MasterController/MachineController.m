//
//  MachineController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//


#import "MachineController.h"
#import "MachineCell.h"

@interface MachineController ()
@property (strong, nonatomic) IBOutlet DropButton *facilityBtn;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UITextField *companyNameTF;
@property (weak, nonatomic) IBOutlet UITextField *facilityNameTF;
@property (nonatomic, assign) BOOL                   isEdit;
@property (nonatomic, strong) NSMutableArray        *allDatas;

@end

@implementation MachineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.footView.height = 0;
    self.footView.alpha = 0;
    
    NSArray *arr = nil;
    [NITUserDefaults setObject:arr forKey:@"SENSORINFO"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getSensorInfo)];
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


- (IBAction)editCell:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"編集"]) {
        [sender setTitle:@"完了" forState:UIControlStateNormal];
        self.isEdit = YES;
        [self ViewAnimateStatas:120];

    }else{
        [sender setTitle:@"編集" forState:UIControlStateNormal];
        self.footView.height = 0;
        self.footView.alpha = 0;
    }

}



- (IBAction)addCell:(id)sender {
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"SENSORINFO"]];
    //    custid = 0002;
    //    custname = "(A)\U30cb\U30c3\U30bb\U30a4\U3000\U82b1\U5b50\U3055\U3093";
    //    nodename = M3;
    //    oldcustid = 0002;
    //    oldserial = 32303136303632323030303030333936;
    //    serial = 32303136303632323030303030333936;
    [arr addObject:@{@"custid":@"",@"custname":@"",@"nodename":@"",@"oldcustid":@"",@"oldserial":@"",@"serial":@""}];
    [NITUserDefaults setObject:arr forKey:@"SENSORINFO"];
    
    [CATransaction setCompletionBlock:^{
        
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }];
    
}

- (IBAction)saveInfo:(id)sender {
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    NSArray *array = [NITUserDefaults objectForKey:@"SENSORINFO"];
    NSError *parseError = nil;
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    NSString *facilitycd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    NSDictionary *dic = @{@"sslist":str,@"facilitycd":facilitycd};
    [MHttpTool postWithURL:NITUpdateSSInfo params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (json) {
            NSString *code = [json objectForKey:@"code"];
            NITLog(@"%@",code);
            [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
            self.footView.height = 0;
            self.footView.alpha = 0;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NITLog(@"%@",error);
    }];
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
    }];
    
}

#pragma mark - Action Handle

/** 機器情報取得 */
- (void)getSensorInfo{
    
    NSString *facd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    NSDictionary *dic = @{@"facilitycd":facd};
    
    [MHttpTool postWithURL:NITGetSSInfo params:dic success:^(id json) {
        
        [self.tableView.mj_header endRefreshing];
        
        if (json) {
            
            NSArray *sslist = [json objectForKey:@"sslist"];
            NSArray *baseinfos = [json objectForKey:@"baseinfo"];
            
            self.companyNameTF.text = [baseinfos.firstObject objectForKey:@"companyname"];
            self.facilityNameTF.text = [baseinfos.firstObject objectForKey:@"facilityname2"];
            
            _allDatas = [NSMutableArray arrayWithArray:sslist.mutableCopy];
            
            [NITUserDefaults setObject:sslist forKey:@"SENSORINFO"];
            
            [self.tableView reloadData];
            
        } else {
            
            NITLog(@"没数据");
            
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        NITLog(@"%@",error);
        
    }];
    
}

-(void)ViewAnimateStatas:(double)statas {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.footView.alpha = statas;
        self.footView.height = statas;
    } completion:^(BOOL finished) {
        [CATransaction setCompletionBlock:^{
            [self.tableView reloadData];
        }];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = [NITUserDefaults objectForKey:@"SENSORINFO"];
    return arr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MachineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MachineCell" forIndexPath:indexPath];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"SENSORINFO"]];
    cell.editOp = self.isEdit;
    cell.cellindex = indexPath.row;
    NSDictionary *dic = arr[indexPath.row];
    if (dic) {
        cell.datasDic = dic.copy;
    }
    
    return cell;
    
}

#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
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

@end
