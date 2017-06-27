//
//  MachineController.m
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/2.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
// 機器情報


#import "MachineController.h"
#import "MachineCell.h"

/**
 その他＞管理者機能＞機器情報画面のコントローラ
 */
@interface MachineController (){
    
    NSString *usertype;
    
}

@property (strong, nonatomic) IBOutlet DropButton   *facilityBtn;

@property (strong, nonatomic) IBOutlet UITableView  *tableView;

@property (strong, nonatomic) IBOutlet UIView       *footView;

@property (weak, nonatomic) IBOutlet UIButton       *editButton;

@property (weak, nonatomic) IBOutlet UITextField    *companyNameTF;

@property (weak, nonatomic) IBOutlet UITextField    *facilityNameTF;

@property (nonatomic, assign) BOOL                   isEdit; // 編集状態

@property (nonatomic, strong) NSMutableArray        *allDatas; //情報データ

@property (nonatomic, assign) NSInteger              numxxid; //追加のIDを許可する

@end

@implementation MachineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.footView.height = 0;
    self.footView.alpha = 0;
    
    // 権限
    usertype = USERTYPE;
    if ([usertype isEqualToString:@"1"] || [usertype isEqualToString:@"2"]) {
        self.editButton.hidden = NO;
    }else{
        self.editButton.hidden = YES;
    }
    
    NSArray *arr = nil;
    [NITUserDefaults setObject:arr forKey:@"SENSORINFO"];//クリア   データ
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getSensorInfo)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    self.isEdit = NO;
    
    // インタラクティブ状態
    self.companyNameTF.userInteractionEnabled = NO;
    self.facilityNameTF.userInteractionEnabled = NO;
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}


#pragma mark - Action Handle

/**
 編集スイッチ
 */
- (IBAction)editCell:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"編集"]) {
        [sender setTitle:@"完了" forState:UIControlStateNormal];
        
        self.isEdit = YES;
        _facilityBtn.showAlert = YES;
        
        if ([usertype isEqualToString:@"1"]) {
            [self ViewAnimateStatas:120];
        }
        
        [self.tableView setEditing:YES animated:YES];
    }else{
        
        [self saveInfo:nil];
        
    }
    
    [CATransaction setCompletionBlock:^{
        
        [self.tableView reloadData];
        
    }];

}
/**
 追加セル
 */
- (IBAction)addCell:(id)sender {
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"SENSORINFO"]]];
    [arr addObject:@{
                     @"custid":@"",
                     
                     @"custname":@"",
                     
                     @"sensorid":@"",
                     
                     @"oldserial":@"",
                     
                     @"serial":@""
                     
                     }];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [NITUserDefaults setObject:data forKey:@"SENSORINFO"];
    
    self.numxxid++;
    
    [self.tableView reloadData];
    
    [CATransaction setCompletionBlock:^{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }];
    
}

//更新データ
- (IBAction)saveInfo:(id)sender {
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    NSArray *array1 = [NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"SENSORINFO"]];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:array1];
    
    NSMutableArray *allarr = [NSMutableArray new];
    
    NSMutableArray *sameMutablearray = [@[] mutableCopy];
    
    
    /**  同じことを取り除く  **/
    for (int i = 0; i < array.count; i ++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:array[i]];
        
        if ([dic[@"custid"] isEqualToString:@"-"]) {
            
            [dic setObject:@"" forKey:@"custid"];
        }
        
        [allarr addObject:dic];
        
        NSMutableArray *tempArray = [@[] mutableCopy];
        
        [tempArray addObject:dic];
        
        for (int j = i+1; j < array.count; j ++) {
            
            NSDictionary *jdic = array[j];
            
            if([dic[@"serial"] isEqualToString:jdic[@"serial"]] || [dic[@"sensorid"] isEqualToString:jdic[@"sensorid"]]){
                
                [tempArray addObject:jdic];
                
                [array removeObjectAtIndex:j];
                
                j -= 1;
                
            }
            
        }
        
        [sameMutablearray addObject:tempArray];
    }
    
    
    if (sameMutablearray.count < array1.count) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [MBProgressHUD showError:@"同じシリアルナンバー或はセンサーIDが存在する"];
        
        return;
    }
    
    
    
    
    NSError *parseError = nil;
    NSData  *json = [NSJSONSerialization dataWithJSONObject:allarr options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    NSString *facilitycd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    NSDictionary *dic = @{
                          
                          @"sslist":str,
                          
                          @"facilitycd":facilitycd
                          
                          };
    
    //更新データ
    [MHttpTool postWithURL:NITUpdateSSInfo params:dic success:^(id json) {
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
                _facilityBtn.showAlert = NO;
                [self.tableView setEditing:NO animated:YES];
                
                [self.tableView.mj_header beginRefreshing];
                
            }else if([code isEqualToString:@"600"]) {
                NSArray *errors = [json objectForKey:@"errors"];
                NSString *errormsg = [errors.firstObject firstObject];
                [MBProgressHUD showError:errormsg]; //
                
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

/**
 動画表示の登録ボタン
 */
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



#pragma mark - Request
//情報取得
- (void)getSensorInfo{
    NSString *facd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    NSDictionary *dic = @{@"facilitycd":facd};
    
    [MHttpTool postWithURL:NITGetSSInfo params:dic success:^(id json) {
        [self.tableView.mj_header endRefreshing];
        _allDatas = [NSMutableArray new];
        NSArray *sslist = [json objectForKey:@"sslist"];
        NSArray *baseinfos = [json objectForKey:@"baseinfo"];
        NSArray *custlist = [json objectForKey:@"custlist"];
        
        if (baseinfos.count >0) {
            self.companyNameTF.text = [baseinfos.firstObject objectForKey:@"companyname"];
            self.facilityNameTF.text = [baseinfos.firstObject objectForKey:@"facilityname2"];
        }
        
        _allDatas = [NSMutableArray arrayWithArray:sslist.mutableCopy];
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:sslist];
        [NITUserDefaults setObject:data forKey:@"SENSORINFO"];
         
        
        
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@{@"custid":@"-",@"custname":@"- -"}];
        [arr addObjectsFromArray:custlist];
        [NITUserDefaults setObject:arr forKey:@"custidlist"];
        
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        NITLog(@"%@",error);
        
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"SENSORINFO"]];
    return arr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MachineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MachineCell" forIndexPath:indexPath];
    
   
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"SENSORINFO"]]];
    
    NSDictionary *dic = arr[indexPath.row];
    
    cell.editOp = self.isEdit;
    
    cell.cellindex = indexPath.row;
    
    if (dic) {
        cell.datasDic = dic.copy;
    }
    
    return cell;
    
}



/**
 tableview 編集状態
 
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.editing)
        return UITableViewCellEditingStyleNone;
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

/**
 削除セル
 */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [NITDeleteAlert SharedAlertShowMessage:@"設定情報を削除します、よろしいですか。" andControl:self withOk:^(BOOL isOk) {
            
            [MBProgressHUD showMessage:@"" toView:self.view];
            NSMutableArray *array = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"SENSORINFO"]]];
            NSDictionary *dic = array[indexPath.row];
            
            if (!dic[@"oldcustid"]) {
                [MBProgressHUD hideHUDForView:self.view];
                
                [array removeObjectAtIndex:indexPath.row];
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:array];
                [NITUserDefaults setObject:data forKey:@"SENSORINFO"];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                [MBProgressHUD showSuccess:@""];
            } else {
                NSString *staffid = [NITUserDefaults objectForKey:@"userid1"];
                
                NSString *facilitycd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
                
                NSDictionary *pdic = @{
                                       @"staffid":staffid,
                                       
                                       @"facilitycd":facilitycd,
                                       
                                       @"custid":dic[@"oldcustid"],
                                       
                                       @"sensorid":dic[@"oldsensorid"],
                                       
                                       @"serial":dic[@"oldserial"],
                                       
                                       @"startdate":dic[@"startdate"]
                                       
                                       };
                
                [MHttpTool postWithURL:NITDeleteSSInfo params:pdic success:^(id json) {
                    
                    [MBProgressHUD hideHUDForView:self.view];
                    
                    if (json) {
                        
                        NSString *code = [json objectForKey:@"code"];
                        
                        NITLog(@"%@",code);
                        
                        if ([code isEqualToString:@"200"]) {
                            [MBProgressHUD showSuccess:@""];
                            [array removeObjectAtIndex:indexPath.row];
                            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:array];
                            [NITUserDefaults setObject:data forKey:@"SENSORINFO"];
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
            
            
        }];
        
    }
    
}


#pragma mark － other
/**
 切替施設  delegate
 */
-(void)SelectedListName:(NSDictionary *)clickDic; {
    [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
    self.footView.height = 0;
    self.footView.alpha = 0;
    self.isEdit = NO;
    [self.tableView setEditing:NO animated:YES];
    _facilityBtn.showAlert = NO;
    [self.tableView.mj_header beginRefreshing];
}


@end
