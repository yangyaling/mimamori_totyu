//
//  IntelligenceMasterController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//　企業マスタ

#import "IntelligenceMasterController.h"
#include "IntelligenceMasterCell.h"

@interface IntelligenceMasterController (){
    NSString *usertype;
}
@property (strong, nonatomic) IBOutlet DropButton     *facilityBtn;

@property (strong, nonatomic) IBOutlet UITableView    *tableView;
@property (strong, nonatomic) IBOutlet UIView         *footView;
@property (strong, nonatomic) IBOutlet UIButton       *editButton;
@property (nonatomic, assign) BOOL                    isEdit;
@property (nonatomic, strong) NSMutableArray          *allDatas;

@end

@implementation IntelligenceMasterController

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
    [NITUserDefaults setObject:arr forKey:@"COMPANYINFO"];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getInfo)];
    
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    self.isEdit = NO;
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
    
}


- (void)getInfo {
    
    [MHttpTool postWithURL:NITGetCompanyInfo params:nil success:^(id json) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        NSArray *tmpArr = [json objectForKey:@"companylist"];
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [self.tableView.mj_header endRefreshing];
        
        if (tmpArr) {
        
            _allDatas = [NSMutableArray arrayWithArray:tmpArr.mutableCopy];
            
            [NITUserDefaults setObject:tmpArr forKey:@"COMPANYINFO"];
            
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
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if ([sender.titleLabel.text isEqualToString:@"編集"]) {
        [sender setTitle:@"完了" forState:UIControlStateNormal];
        self.isEdit = YES;
        [self ViewAnimateStatas:60];
        
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
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"COMPANYINFO"]];
    [arr addObject:@{
                     @"cd":@"",
                     
                     @"initial":@"",
                     
                     @"kana":@"",
                     
                     @"name":@""
                     
                     }];
    [NITUserDefaults setObject:arr forKey:@"COMPANYINFO"];
    
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }];
}

- (IBAction)saveInfo:(id)sender {
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    
    NSArray *array = [NITUserDefaults objectForKey:@"COMPANYINFO"];
    
    NSError *parseError = nil;
    
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{@"companylist":str};
    
    [MHttpTool postWithURL:NITUpdateCompanyInfo params:dic success:^(id json) {
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
//        [self.tableView setEditing:NO animated:YES];
        NITLog(@"%@",error);
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = [NITUserDefaults objectForKey:@"COMPANYINFO"];
    return arr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntelligenceMasterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntelligenceMasterCell" forIndexPath:indexPath];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"COMPANYINFO"]];
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
            NSMutableArray *array =[NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"COMPANYINFO"]];
            NSDictionary *dic = array[indexPath.row];
            NSDictionary *DeleteCompany = @{@"companycd" : dic[@"cd"]};
            
            [MHttpTool postWithURL:NITDeleteCompanyInfo params:DeleteCompany success:^(id json) {
                
                [MBProgressHUD hideHUDForView:self.view];
                
                if (json) {
                    
                    NSString *code = [json objectForKey:@"code"];
                    
                    NITLog(@"%@",code);
                    
                    if ([code isEqualToString:@"200"]) {
                        [MBProgressHUD showSuccess:@""];
                        [array removeObjectAtIndex:indexPath.row];
                        
                        [NITUserDefaults setObject:array forKey:@"COMPANYINFO"];
                        
                        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                        
                        [self.tableView.mj_header beginRefreshing];
                        
                    } else {
                        
                        [MBProgressHUD showError:@""];
                        
                    }
                }
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD hideHUDForView:self.view];
                
                NITLog(@"%@",error);
            }];

        }];
        
    }
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
    }];
}


@end
