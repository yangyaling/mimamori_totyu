//
//  UserMasterController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//  使用者情報

#import "UserMasterController.h"
#import "UserMasterCell.h"


@interface UserMasterController (){
    NSString *usertype;
}

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

@property (strong, nonatomic) IBOutlet AnimationView  *editAnimationView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *editAnimationViewLayout;

@end

@implementation UserMasterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.footView.height = 0;
    self.footView.alpha = 0;
    
    //　権限
    usertype = USERTYPE;
    if ([usertype isEqualToString:@"x"] || [usertype isEqualToString:@"1"]|| [usertype isEqualToString:@"2"]) {
        self.editButton.hidden = NO;
    }else{
        self.editButton.hidden = YES;
    }
    
    NSArray *arr = nil;
    [NITUserDefaults setObject:arr forKey:@"STAFFINFO"];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getnlInfo)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    self.isEdit = NO;
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}


-(void)SelectedListName:(NSDictionary *)clickDic {
    [self.tableView.mj_header beginRefreshing];
}


//数据请求
- (void)getnlInfo {
    
    NSString *facd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
   
    
    NSDictionary *dic = @{@"facilitycd":facd,@"usertype":usertype};
    
    [MHttpTool postWithURL:NITGetStaffInfo params:dic success:^(id json) {
        
        [self.tableView.mj_header endRefreshing];
        self.allDatas = [NSMutableArray new];
        NSArray *stafflist = [json objectForKey:@"stafflist"];
        NSArray *baseinfos = [json objectForKey:@"baseinfo"];
        NSArray *btnL = [json objectForKey:@"usertypelist"];
        
        
        self.maxId = [json objectForKey:@"maxstaffid"];
                
        
        _allDatas = [NSMutableArray arrayWithArray:stafflist.mutableCopy];
            
        [NITUserDefaults setObject:stafflist forKey:@"STAFFINFO"];
        
        
        if (baseinfos.count > 0) {
            self.companyName.text = [baseinfos.firstObject objectForKey:@"companyname"];
            
            self.facilityName.text = [baseinfos.firstObject objectForKey:@"facilityname2"];
        }
        
            
        [NITUserDefaults setObject:btnL forKey:@"usertypelist"];
            
        
        [self.tableView reloadData];
        
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
        
        
        [self.tableView setEditing:YES animated:YES];
        
        [self.editAnimationView StartAnimationXLayoutConstraint:self.editAnimationViewLayout];

    }else{
        
        
//        [sender setTitle:@"編集" forState:UIControlStateNormal];
        
        [self saveNow:nil]; //跟新或者追加
        
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
    
    if (![self.maxId isEqualToString:@""]) {
        
        NSString *laststr = [self.maxId substringFromIndex:self.maxId.length - 5];
        NSString *fiststr = [self.maxId substringToIndex:self.maxId.length - 5];
        
        NSInteger numId = [laststr integerValue] + self.numxxid;
        
        NSString *staffidstr = [NSString stringWithFormat:@"%@%05i",fiststr,(int)numId];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"STAFFINFO"]];
        
        [arr addObject:@{
                         @"nickname":@"",
                         
                         @"staffid":staffidstr,
                         
                         @"usertype":@"",
                         
                         @"oldusertype":@"",
                         
                         @"usertypename":@""
                         
                         }];
        [NITUserDefaults setObject:arr forKey:@"STAFFINFO"];
        
        self.numxxid++;
        
        [self.tableView reloadData];
        [CATransaction setCompletionBlock:^{
            
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }];
        
    }else{
        [self getnlInfo];
    }
    
}

- (IBAction)saveNow:(id)sender {
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    NSString *facilitycd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    
    NSArray *array = [NITUserDefaults objectForKey:@"STAFFINFO"];
    
    NSError *parseError = nil;
    
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{
                          @"stafflist":str,
                          
                          @"facilitycd":facilitycd
                          
                          };
    
    [MHttpTool postWithURL:NITUpdateStaffInfo params:dic success:^(id json) {
        
        [MBProgressHUD hideHUDForView:self.view];
        if (json) {
            NSString *code = [json objectForKey:@"code"];
            NITLog(@"%@",code);
            if ([code isEqualToString:@"200"]) {
                [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
                [MBProgressHUD showSuccess:@""];
               
                [self.tableView setEditing:NO animated:YES];
                
                self.footView.height = 0;
                self.footView.alpha = 0;
                self.isEdit = NO;
                [self.editAnimationView FinishAnimationZoneLayoutConstraint:self.editAnimationViewLayout];
                
                [CATransaction setCompletionBlock:^{
                    [self.tableView reloadData];
                    [self.tableView.mj_header beginRefreshing];
                }];
                
            } else {
                [MBProgressHUD showError:@""];
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
    if (!tableView.editing)
        return UITableViewCellEditingStyleNone;
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [NITDeleteAlert SharedAlertShowMessage:@"設定情報を削除します、よろしいですか。" andControl:self withOk:^(BOOL isOk) {
            [MBProgressHUD showMessage:@"" toView:self.view];
            NSMutableArray *array = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"STAFFINFO"]];
            NSDictionary *dic = array[indexPath.row];
            
            NSString *utype = [NSString stringWithFormat:@"%@", dic[@"usertype"]];
            
            
            if ([dic[@"oldusertype"] isEqualToString:@""]) {
                [MBProgressHUD hideHUDForView:self.view];
                
                [array removeObjectAtIndex:indexPath.row];
                [NITUserDefaults setObject:array forKey:@"STAFFINFO"];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                
                [MBProgressHUD showSuccess:@""];
            } else {
                NSString *staffid = dic[@"staffid"];
                
                NSString *facd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
                
                NSDictionary *pdic = @{
                                       
                                       @"staffid":staffid,
                                       
                                       @"facilitycd":facd
                                       
                                       };
                
                if ([usertype isEqualToString:@"2"] && [utype isEqualToString:@"1"]) {
                    [MBProgressHUD hideHUDForView:self.view];
                    [MBProgressHUD showError:@""];
                    
                } else if ([usertype isEqualToString:@"1"]) {
                    [MHttpTool postWithURL:NITDeleteStaffInfo params:pdic success:^(id json) {
                        
                        [MBProgressHUD hideHUDForView:self.view];
                        
                        if (json) {
                            
                            NSString *code = [json objectForKey:@"code"];
                            
                            NITLog(@"%@",code);
                            
                            if ([code isEqualToString:@"200"]) {
                                
                                [MBProgressHUD showSuccess:@""];
                                
                                [array removeObjectAtIndex:indexPath.row];
                                [NITUserDefaults setObject:array forKey:@"STAFFINFO"];
                                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                                
                                [self.tableView.mj_header beginRefreshing];
                                
                            } else {
                                
                                [MBProgressHUD showError:@""];
                                
                            }
                            [CATransaction setCompletionBlock:^{
                                [self.tableView reloadData];
                            }];
                        }
                        
                    } failure:^(NSError *error) {
                        [MBProgressHUD hideHUDForView:self.view];
                        NITLog(@"%@",error);
                    }];

                } else {
                    
                    [MHttpTool postWithURL:NITDeleteStaffInfo params:pdic success:^(id json) {
                        
                        [MBProgressHUD hideHUDForView:self.view];
                        
                        if (json) {
                            
                            NSString *code = [json objectForKey:@"code"];
                            
                            NITLog(@"%@",code);
                            
                            if ([code isEqualToString:@"200"]) {
                                
                                [MBProgressHUD showSuccess:@""];
                                
                                [array removeObjectAtIndex:indexPath.row];
                                [NITUserDefaults setObject:array forKey:@"STAFFINFO"];
                                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                                
                                [self.tableView.mj_header beginRefreshing];
                                
                            } else {
                                
                                [MBProgressHUD showError:@""];
                                
                            }
                            [CATransaction setCompletionBlock:^{
                                [self.tableView reloadData];
                            }];
                        }
                        
                    } failure:^(NSError *error) {
                        [MBProgressHUD hideHUDForView:self.view];
                        NITLog(@"%@",error);
                    }];

                }
            }
            
        }];
        
    }
    
}


@end
