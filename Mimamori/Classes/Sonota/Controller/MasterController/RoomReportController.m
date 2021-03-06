//
//  RoomReportController.m
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/4.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//  居室場所

#import "RoomReportController.h"
#import "RoomReportCell.h"

@interface RoomReportController (){
    NSString *usertype;
}

@property (strong, nonatomic) IBOutlet UITextField        *hostID;

@property (strong, nonatomic) IBOutlet UITextField        *facilityName1;

@property (strong, nonatomic) IBOutlet DropButton         *facilityBtn;

@property (strong, nonatomic) IBOutlet UITableView        *tableView;
@property (strong, nonatomic) IBOutlet UIView             *footView;

@property (nonatomic, assign) BOOL                         isEdit;  // 編集状態

@property (strong, nonatomic) IBOutlet UIButton           *editButton;

@property (nonatomic, strong) NSMutableArray              *allDatas; //情報データ

@property (strong, nonatomic) IBOutlet AnimationView      *editAnimationView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *editAnimationViewLayout;

@end

@implementation RoomReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.footView.height = 0;
    self.footView.alpha = 0;
    
    // 権限
    usertype = USERTYPE;
    if ([usertype isEqualToString:@"1"]) {
        self.editButton.hidden = NO;
    }else{
        self.editButton.hidden = YES;
    }
    
    NSArray *arr = nil;
    [NITUserDefaults setObject:arr forKey:@"ROOMMASTERINFOKEY"]; //クリア   データ
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getnlInfo)];
    
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    self.isEdit = NO;
    
    
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}
/**
 切替施設  delegate
 */
-(void)SelectedListName:(NSDictionary *)clickDic {
    [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
    
    [self.tableView setEditing:NO animated:YES];
    
    self.footView.height = 0;
    self.footView.alpha = 0;
    self.isEdit = NO;
    
    [self.editAnimationView FinishAnimationZoneLayoutConstraint:self.editAnimationViewLayout];
    
    _facilityBtn.showAlert = NO;
    [self.tableView.mj_header beginRefreshing];
}


//情報取得
- (void)getnlInfo {
    
    NSString *facd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    
    NSDictionary *dic = @{@"facilitycd":facd};
    
    [MHttpTool postWithURL:NITGetRoomInfo params:dic success:^(id json) {
        
        [self.tableView.mj_header endRefreshing];
        self.allDatas = [NSMutableArray new];
        NSArray *baseinfos = [json objectForKey:@"baseinfo"];
        
        NSArray *roomlist = [json objectForKey:@"roomlist"];
    
        
        if (baseinfos.count > 0) {
            
            self.hostID.text = [baseinfos.firstObject objectForKey:@"hostcd"];
            
            self.facilityName1.text = [baseinfos.firstObject objectForKey:@"facilityname2"];
            
        }
        
        
        _allDatas = [NSMutableArray arrayWithArray:roomlist.mutableCopy];
            
        [NITUserDefaults setObject:roomlist forKey:@"ROOMMASTERINFOKEY"];
            
     
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        NITLog(@"%@",error);
        
    }];
    
}

/**
 編集スイッチ
 */
- (IBAction)editCell:(UIButton *)sender {
    
    
    
    if ([sender.titleLabel.text isEqualToString:@"編集"]) {
        [sender setTitle:@"完了" forState:UIControlStateNormal];
        
        [self.tableView setEditing:YES animated:YES];
        self.isEdit = YES;
        _facilityBtn.showAlert = YES;
        [self ViewAnimateStatas:120];
        [self.editAnimationView StartAnimationXLayoutConstraint:self.editAnimationViewLayout];
        //进入编辑状态
    }else{
        
        [self saveInfo:nil]; //跟新或者追加
        
    }
    
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
    }];
    
}

/**
 動画表示の登録ボタン
 */
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
/**
 追加セル
 */
- (IBAction)addCell:(id)sender {
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"ROOMMASTERINFOKEY"]];
    [arr addObject:@{
                     
                     @"floorno":@"",
                     
                     @"roomcd":@"",
                     
                     @"oldfloorno":@"",
                     
                     @"oldroomcd":@""
                     
                     }];
    [NITUserDefaults setObject:arr forKey:@"ROOMMASTERINFOKEY"];
//
    [self.tableView reloadData];
    [CATransaction setCompletionBlock:^{
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }];
    
}

//更新データ
- (IBAction)saveInfo:(id)sender {
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    
    NSArray *array = [NITUserDefaults objectForKey:@"ROOMMASTERINFOKEY"];
    
    NSError *parseError = nil;
    
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    NSString *facd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    
    NSDictionary *dic = @{
                          @"roomlist":str,
                          
                          @"facilitycd":facd
                          
                          };
    
    [MHttpTool postWithURL:NITUpdateRoomInfo params:dic success:^(id json) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (json) {
            
            NSString *code = [json objectForKey:@"code"];
            
            NITLog(@"%@",code);
            
            if ([code isEqualToString:@"200"]) {
                
                [MBProgressHUD showSuccess:@""];
                
                [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
                
                [self.tableView setEditing:NO animated:YES];
                
                self.footView.height = 0;
                self.footView.alpha = 0;
                self.isEdit = NO;
                
                [self.editAnimationView FinishAnimationZoneLayoutConstraint:self.editAnimationViewLayout];
                
                _facilityBtn.showAlert = NO;
                
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
    
    NSArray *arr = [NITUserDefaults objectForKey:@"ROOMMASTERINFOKEY"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"ROOMMASTERINFOKEY"]];
            
            
            NSDictionary *dic = array[indexPath.row];
            
            if ([dic[@"oldfloorno"] isEqualToString:@""] || [dic[@"oldroomcd"] isEqualToString:@""]) {
                
                [MBProgressHUD hideHUDForView:self.view];
                
                [array removeObjectAtIndex:indexPath.row];
                
                [NITUserDefaults setObject:array forKey:@"ROOMMASTERINFOKEY"];
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                
                [MBProgressHUD showSuccess:@""];
                
            } else {
                NSString *facilitycd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
                
                NSString *oldfloorno = [NSString stringWithFormat:@"%@",dic[@"oldfloorno"]];
                
                NSString *oldroomcd = [NSString stringWithFormat:@"%@",dic[@"oldroomcd"]];
                
                
                NSDictionary *paradic = @{
                                          @"facilitycd":facilitycd,
                                          
                                          @"floorno":oldfloorno,
                                          
                                          @"roomcd":oldroomcd
                                          
                                          };
                
                [MHttpTool postWithURL:NITDeleteRoomInfo params:paradic success:^(id json) {
                    
                    [MBProgressHUD hideHUDForView:self.view];
                    
                    if (json) {
                        
                        NSString *code = [json objectForKey:@"code"];
                        
                        NITLog(@"%@",code);
                        
                        if ([code isEqualToString:@"200"]) {
                            [array removeObjectAtIndex:indexPath.row];
                            [MBProgressHUD showSuccess:@""];
                            [NITUserDefaults setObject:array forKey:@"ROOMMASTERINFOKEY"];
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

@end
