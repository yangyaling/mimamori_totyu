//
//  PlaceSettingController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/4/28.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "PlaceSettingController.h"
#import "PlaceSettingCell.h"


@interface PlaceSettingController (){
    NSString *usertype;
}
@property (strong, nonatomic) IBOutlet DropButton   *facilityBtn;

@property (strong, nonatomic) IBOutlet UITableView  *tableView;

@property (strong, nonatomic) IBOutlet UIView       *footView;


@property (nonatomic, strong) NSMutableArray        *allDatas;

@property (nonatomic, assign) BOOL                   isEdit;
@property (strong, nonatomic) IBOutlet UIButton     *editButton;

@property (strong, nonatomic) IBOutlet AnimationView  *editAnimationView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *editAnimationViewLayout;

@end

@implementation PlaceSettingController

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
    [NITUserDefaults setObject:arr forKey:@"NLINFO"];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getnlInfo)];
    
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    self.isEdit = NO;
}



//NITUpdateNLInfo

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}


//数据请求
- (void)getnlInfo {
    
    [MHttpTool postWithURL:NITGetNLInfo params:nil success:^(id json) {
        
        
        NSArray *tmpArr = [json objectForKey:@"nllist"];
                
        [self.tableView.mj_header endRefreshing];
        
        if (tmpArr) {
            
            _allDatas = [NSMutableArray arrayWithArray:tmpArr.mutableCopy];
            
            [NITUserDefaults setObject:tmpArr forKey:@"NLINFO"];
            
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
        self.isEdit = YES;
        
        [self ViewAnimateStatas:120];
        [self.tableView setEditing:YES animated:YES];
        
        [self.editAnimationView StartAnimationXLayoutConstraint:self.editAnimationViewLayout];

    }else{
        [self saveInfo:nil]; //跟新或者追加
    }
    
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
    }];
    
}

- (IBAction)saveInfo:(id)sender {
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    NSArray *array = [NITUserDefaults objectForKey:@"NLINFO"];
    
    NSError *parseError = nil;
    
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{@"nllist":str};
    
    [MHttpTool postWithURL:NITUpdateNLInfo params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (json) {
            NSString *code = [json objectForKey:@"code"];
            NITLog(@"%@",code);
            
            if ([code isEqualToString:@"200"]) {
                
//                [MBProgressHUD showSuccess:@""];
                
                [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
                self.footView.height = 0;
                self.footView.alpha = 0;
                self.isEdit = NO;
                [self.tableView setEditing:NO animated:YES];
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
        [self.tableView setEditing:NO animated:YES];
        NITLog(@"%@",error);
    }];
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
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"NLINFO"]];
    
    [arr addObject:@{
                     @"cd":@"",
                     
                     @"name":@""
                     
                     }];
    
    [NITUserDefaults setObject:arr forKey:@"NLINFO"];
    
    [CATransaction setCompletionBlock:^{
        
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
    }];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = [NITUserDefaults objectForKey:@"NLINFO"];
    return arr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell" forIndexPath:indexPath];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"NLINFO"]];
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
            
            NSMutableArray *array =[NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"NLINFO"]];
            
            NSDictionary *dic = array[indexPath.row];
            
            if (!dic[@"oldcd"]) {
                
                [MBProgressHUD hideHUDForView:self.view];
                
                [array removeObjectAtIndex:indexPath.row];
                
                [NITUserDefaults setObject:array forKey:@"NLINFO"];
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                
                [MBProgressHUD showSuccess:@""];
                
            } else {
                [MHttpTool postWithURL:NITDeleteNLInfo params:dic success:^(id json) {
                    
                    [MBProgressHUD hideHUDForView:self.view];
                    
                    if (json) {
                        
                        NSString *code = [json objectForKey:@"code"];
                        
                        NITLog(@"%@",code);
                        
                        if ([code isEqualToString:@"200"]) {
                            [MBProgressHUD showSuccess:@""];
                            [array removeObjectAtIndex:indexPath.row];
                            
                            [NITUserDefaults setObject:array forKey:@"NLINFO"];
                            
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
