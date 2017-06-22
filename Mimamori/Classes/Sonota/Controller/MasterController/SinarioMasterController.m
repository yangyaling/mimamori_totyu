//
//  SinarioMasterController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//　シナリオマスタ

#import "SinarioMasterController.h"
#import "SinarioMasterCell.h"

#import "EditSinarioController.h"

/**
 その他＞管理者機能＞マスター関連>シナリオマスタ画面のコントローラ
 */
@interface SinarioMasterController (){
    
    NSString *usertype;
    
}

@property (strong, nonatomic) IBOutlet DropButton   *facilityBtn;
@property (strong, nonatomic) IBOutlet UITableView  *tableView;

@property (nonatomic, assign) BOOL                  isOpen;  //追加雛形（雛形詳細）
@property (nonatomic, strong) NSMutableArray        *allDatas;   //雛形データ一覧

@property (nonatomic, strong) NSString              *maxid; //追加のIDを許可する
@property (strong, nonatomic) IBOutlet UIButton     *addButton;

@end

@implementation SinarioMasterController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.isOpen = YES;
    
    // 権限
    usertype = USERTYPE;
    if ([usertype isEqualToString:@"1"]) {
        self.addButton.hidden = NO;
    }else{
        self.addButton.hidden = YES;
    }
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getnlInfo)];
    
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
    
    [self getnlInfo];
}


//情報取得
- (void)getnlInfo {
    
    [MHttpTool postWithURL:NITGetSPList params:nil success:^(id json) {
        
        [self.tableView.mj_header endRefreshing];
        
        self.maxid = [json objectForKey:@"maxprotoid"];
        
        if (self.maxid.length > 0) {
            
            [self.addButton setEnabled:YES];
            
            [self.addButton setBackgroundColor:NITColor(253, 85, 95)];
            
        }
        
        NSArray *tmpArr = [json objectForKey:@"splist"];
        
        if (tmpArr.count > 0) {

            _allDatas = [NSMutableArray arrayWithArray:tmpArr.mutableCopy];
 
            [self.tableView reloadData];
            
        } else {
            
            NITLog(@"没数据");
            
        }
        
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
    
    return self.allDatas.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SinarioMasterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SinarioMasterCell" forIndexPath:indexPath];
    NSDictionary *dic = _allDatas[indexPath.row];
    if (dic) {
        cell.datasDic = dic.copy;
    }
    
    return cell;
}

//tableviewcell push
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isOpen = YES;
    [self performSegueWithIdentifier:@"pushEditSinarioMaster" sender:self];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return UITableViewCellEditingStyleDelete;
}

/**
 削除セル
 */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [NITDeleteAlert SharedAlertShowMessage:@"設定情報を削除します、よろしいですか。" andControl:self withOk:^(BOOL isOk) {
            
            [MBProgressHUD showMessage:@"" toView:self.view];
            
            NSDictionary *dic = self.allDatas[indexPath.row];
            
            NSString *protoid = [NSString stringWithFormat:@"%@",dic[@"protoid"]];
            
            NSDictionary *pdic = @{@"protoid":protoid};
            
            
            [MHttpTool postWithURL:NITDeleteSPInfo params:pdic success:^(id json) {
                
                [MBProgressHUD hideHUDForView:self.view];
                
                if (json) {
                    
                    NSString *code = [json objectForKey:@"code"];
                    
                    NITLog(@"%@",code);
                    
                    if ([code isEqualToString:@"200"]) {
                        
                        [MBProgressHUD showSuccess:@""];
                        
                        [self.allDatas removeObjectAtIndex:indexPath.row];
                        
                        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                        
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
                
                NITLog(@"%@",error);
                
            }];
           
        }];
        
    }
    
    
}


/** 追加ボタンを押す */
- (IBAction)addEditSinarioMaster:(UIButton *)sender {
    self.isOpen = NO;
    [self performSegueWithIdentifier:@"pushEditSinarioMaster" sender:self];
}



/**
 Push ->パラメータ付値
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    EditSinarioController *esc = segue.destinationViewController;
    
    if (self.isOpen) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        esc.labelTitle = @"詳細";
        esc.isEdit = YES;
        esc.maxid = [self.allDatas[indexPath.row] objectForKey:@"protoid"];
        
    } else {
        esc.labelTitle = @"新規追加";
        esc.isEdit = NO;
        esc.maxid = self.maxid;
        
    }
}
@end
