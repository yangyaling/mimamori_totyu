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

@property (strong, nonatomic) IBOutlet AnimationView  *editAnimationView;

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
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *editAnimationViewLayout;
@end

@implementation HomeMasterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.footView.height = 0;
    self.footView.alpha = 0;
    
    //　権限
    usertype = USERTYPE;
    if ([usertype isEqualToString:@"1"] || [usertype isEqualToString:@"2"]) {
        self.editButton.hidden = NO;
    }else{
        self.editButton.hidden = YES;
    }
    
    NSArray *arr = nil;
    [NITUserDefaults setObject:arr forKey:@"HOMECUSTINFO"];
    
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getnlInfo)];
    
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    self.isEdit = NO;
    
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}

-(void)SelectedListName:(NSDictionary *)clickDic {
    
    [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
    
    self.footView.height = 0;
    
    self.footView.alpha = 0;
    
    self.isEdit = NO;
    
    [self.tableView setEditing:NO animated:YES];
    
    _facilityBtn.showAlert = NO;
    
    [self.editAnimationView FinishAnimationZoneLayoutConstraint:self.editAnimationViewLayout];
    
    [self.tableView.mj_header beginRefreshing];
}

//数据请求
- (void)getnlInfo {
    
    NSString *facd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    
    NSDictionary *dic = @{@"facilitycd":facd};
    
    [MHttpTool postWithURL:NITGetHomeCustInfo params:dic success:^(id json) {
        
        [self.tableView.mj_header endRefreshing];
        self.allDatas = [NSMutableArray new];
        NSArray *baseinfos = [json objectForKey:@"baseinfo"];
        
        NSArray *btnF = [json objectForKey:@"floorlist"];
        
        
        NSArray *custlist = [json objectForKey:@"custlist"];
        
        self.maxId = [NSString stringWithFormat:@"%@", [json objectForKey:@"maxcustid"]];
        
        
        if (baseinfos.count > 0) {
            
            self.companyName.text = [baseinfos.firstObject objectForKey:@"companyname"];
            
            self.facilityName.text = [baseinfos.firstObject objectForKey:@"facilityname2"];
            
        }
        
        if (btnF.count == 0) {
            NSDictionary *tmpdic = @{@"roomcd":@"-"};
            NSDictionary *dic = @{@"floorno":@"-",@"roomlist":@[tmpdic]};
            NSMutableArray *addListArray = [NSMutableArray array];
            [addListArray addObject:dic];
            [addListArray addObjectsFromArray:btnF];
            [NITUserDefaults setObject:addListArray forKey:@"FLOORLISTKEY"];
        } else {
            [NITUserDefaults setObject:btnF forKey:@"FLOORLISTKEY"];
        }
        
        
        
            
        _allDatas = [NSMutableArray arrayWithArray:custlist.mutableCopy];
            
        [NITUserDefaults setObject:custlist forKey:@"HOMECUSTINFO"];
        
        
            
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
        _facilityBtn.showAlert = YES;
        [self.editAnimationView StartAnimationXLayoutConstraint:self.editAnimationViewLayout];
        
        
        self.isEdit = YES;
        [self ViewAnimateStatas:120];
        
    }else{
        
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
    
    NSArray *floorlist = [NITUserDefaults objectForKey:@"FLOORLISTKEY"];
    
    
    NSString *floorno = [NSString stringWithFormat:@"%@",[floorlist.firstObject objectForKey:@"floorno"]];
    NSString *roomcd = [NSString stringWithFormat:@"%@",[[[floorlist.firstObject objectForKey:@"roomlist"] firstObject] objectForKey:@"roomcd"]];
    
    [arr addObject:@{
                     @"custid":cusstidstr,
                     
                     @"custname":@"",
                     
                     @"floorno":floorno,
                     
                     @"roomcd":roomcd,
                     
                     @"oldfloorno":floorno,
                     
                     @"oldroomcd":roomcd
                     }
     ];
    
    [NITUserDefaults setObject:arr forKey:@"HOMECUSTINFO"];
    
    self.numxxid++;
    
     [self.tableView reloadData];
    [CATransaction setCompletionBlock:^{
        
       
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
    }];
    
}




- (IBAction)saveInfo:(id)sender {
   
    
    NSArray *array = [NITUserDefaults objectForKey:@"HOMECUSTINFO"];
    
    for (NSDictionary * dic in array) {
        if ([dic[@"floorno"] isEqualToString:@"-"] || [dic[@"roomcd"] isEqualToString:@"-"]) {
            array = nil;
            break;
        }
    }
    
    if (array.count  ==  0) {
        [MBProgressHUD showError:@"階と居室番号は居室情報にて設定してください。"];
        return;
    }
    
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
                [MBProgressHUD showSuccess:@""];
                [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
                
                self.footView.height = 0;
                
                self.footView.alpha = 0;
                
                self.isEdit = NO;
                
                [self.tableView setEditing:NO animated:YES];
                
                _facilityBtn.showAlert = NO;
                
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
            NSMutableArray *array = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"HOMECUSTINFO"]];
            NSDictionary *dic = array[indexPath.row];
            
            if (!dic[@"oldcustid"]) {
                [MBProgressHUD hideHUDForView:self.view];
                
                [array removeObjectAtIndex:indexPath.row];
                [NITUserDefaults setObject:array forKey:@"HOMECUSTINFO"];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                
                [MBProgressHUD showSuccess:@""];
            } else {
                NSString *staffid = [NITUserDefaults objectForKey:@"userid1"];
                
                NSDictionary *pdic = @{
                                       @"staffid":staffid,
                                       
                                       @"custid":dic[@"custid"],
                                       
                                       @"floorno":dic[@"oldfloorno"],
                                       
                                       @"roomcd":dic[@"oldroomcd"]
                                       
                                       };
                
                
                [MHttpTool postWithURL:NITDeleteHomeCustInfo params:pdic success:^(id json) {
                    
                    [MBProgressHUD hideHUDForView:self.view];
                    
                    if (json) {
                        
                        NSString *code = [json objectForKey:@"code"];
                        
                        NITLog(@"%@",code);
                        
                        if ([code isEqualToString:@"200"]) {
                            
                            [MBProgressHUD showSuccess:@""];
                            
                            [array removeObjectAtIndex:indexPath.row];
                            [NITUserDefaults setObject:array forKey:@"HOMECUSTINFO"];
                            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                            
                            [self.tableView.mj_header beginRefreshing];
                            
                        } else {
                            
                            //                        self.footView.height = 0;
                            //                        self.footView.alpha = 0;
                            //                        self.isEdit = NO;
                            //                        [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
                            //                        [self.tableView setEditing:NO animated:YES];
                            
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
            
        }];
        
    }
    
    
}

@end
