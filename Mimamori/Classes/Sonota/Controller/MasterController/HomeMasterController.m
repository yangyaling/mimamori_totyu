//
//  HomeMasterController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "HomeMasterController.h"
#import "HomeMasterCell.h"

@interface HomeMasterController (){
    NSString *usertype;
}
@property (strong, nonatomic) IBOutlet DropButton *facilityBtn;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UITextField *companyName;

@property (strong, nonatomic) IBOutlet UITextField *facilityName;

@property (nonatomic, assign) BOOL                   isEdit;
@property (strong, nonatomic) IBOutlet UIButton     *editButton;
@property (nonatomic, strong) NSMutableArray        *allDatas;
@property (nonatomic, strong) NSString              *maxId;
@property (nonatomic, assign) NSInteger             numxxid;
@end

@implementation HomeMasterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.footView.height = 0;
    self.footView.alpha = 0;
    //　権限
    usertype = USERTYPE;
//    if ([usertype isEqualToString:@"1"]) {
//        self.editButton.hidden = NO;
//    }else{
//        self.editButton.hidden = YES;
//    }
    
    NSArray *arr = nil;
    [NITUserDefaults setObject:arr forKey:@"HOMECUSTINFO"];
    
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    
    [MHttpTool postWithURL:NITGetHomeCustInfo params:dic success:^(id json) {
        
        [self.tableView.mj_header endRefreshing];
        
        NSArray *baseinfos = [json objectForKey:@"baseinfo"];
        
        NSArray *btnF = [json objectForKey:@"floorlist"];
        
        NSArray *btnR = [json objectForKey:@"roomlist"];
        
        NSArray *custlist = [json objectForKey:@"custlist"];
        
        self.maxId = [NSString stringWithFormat:@"%@", [json objectForKey:@"maxcustid"]];
        
        
        if (baseinfos.count > 0) {
            
            self.companyName.text = [baseinfos.firstObject objectForKey:@"companyname"];
            
            self.facilityName.text = [baseinfos.firstObject objectForKey:@"facilityname2"];
            
        }
        
        
        if (btnF.count >0) {
            [NITUserDefaults setObject:btnF forKey:@"FLOORLISTKEY"];
        }
        
        if (btnR.count >0) {
            [NITUserDefaults setObject:btnR forKey:@"ROOMLISTKEY"];
        }
        
        
        if (custlist.count >0) {
            
            _allDatas = [NSMutableArray arrayWithArray:custlist.mutableCopy];
            
            [NITUserDefaults setObject:custlist forKey:@"HOMECUSTINFO"];
            
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
         [self.tableView setEditing:YES animated:YES];
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
    
    if (!self.maxId.length) return;
    
    NSString *laststr = [self.maxId substringFromIndex:self.maxId.length - 5];
    NSString *fiststr = [self.maxId substringToIndex:self.maxId.length - 5];
    
    NSInteger numId = [laststr integerValue] + self.numxxid;

    NSString *cusstidstr = [NSString stringWithFormat:@"%@%05i",fiststr,(int)numId];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"HOMECUSTINFO"]];
    [arr addObject:@{@"custid":cusstidstr,@"custname":@"",@"floorno":@"",@"roomcd":@""}];
    [NITUserDefaults setObject:arr forKey:@"HOMECUSTINFO"];
    
    self.numxxid++;
    
    
    [CATransaction setCompletionBlock:^{
        
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }];
    
}




- (IBAction)saveInfo:(id)sender {
   
    
    
    NSArray *array = [NITUserDefaults objectForKey:@"HOMECUSTINFO"];
    if (array.count  ==  0) return;
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    NSError *parseError = nil;
    
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    NSString *facilitycd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    
    NSDictionary *dic = @{@"custlist":str,@"facilitycd":facilitycd};
    
    
    [MHttpTool postWithURL:NITUpdateHomeCustInfo params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (json) {
            NSString *code = [json objectForKey:@"code"];
            NITLog(@"%@",code);
            if ([code isEqualToString:@"200"]) {
                [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
                //            [self.tableView setEditing:NO animated:YES];
                self.footView.height = 0;
                self.footView.alpha = 0;
                self.isEdit = NO;
                [self.tableView setEditing:NO animated:YES];
                [self.tableView reloadData];
            }
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
    
    NSArray *arr = [NITUserDefaults objectForKey:@"HOMECUSTINFO"];
    return arr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeMasterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMasterCell" forIndexPath:indexPath];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"HOMECUSTINFO"]];
    cell.editOp = self.isEdit;
    cell.cellindex = indexPath.row;
    NSDictionary *dic = arr[indexPath.row];
    if (dic) {
        cell.datasDic = dic.copy;
    }
    return cell;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [MBProgressHUD showMessage:@"" toView:self.view];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"HOMECUSTINFO"]];
        NSDictionary *dic = array[indexPath.row];
        
        
        [MHttpTool postWithURL:NITDeleteHomeCustInfo params:dic success:^(id json) {
            
            [MBProgressHUD hideHUDForView:self.view];
            
            if (json) {
                
                NSString *code = [json objectForKey:@"code"];
                
                NITLog(@"%@",code);
                
                if ([code isEqualToString:@"502"]) {
                    
                    [MBProgressHUD showError:@""];
                    
                } else {
                    self.footView.height = 0;
                    self.footView.alpha = 0;
                    self.isEdit = NO;
                    [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
                    [self.tableView setEditing:NO animated:YES];
                    
                    [array removeObjectAtIndex:indexPath.row];
                    [NITUserDefaults setObject:array forKey:@"HOMECUSTINFO"];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                    
                }
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            NITLog(@"%@",error);
        }];
        
    }
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
    }];
}

@end
