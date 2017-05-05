//
//  SinarioMasterController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "SinarioMasterController.h"
#import "SinarioMasterCell.h"

#import "EditSinarioController.h"

@interface SinarioMasterController ()
@property (strong, nonatomic) IBOutlet DropButton *facilityBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL                  isOpen;
@property (nonatomic, strong) NSMutableArray        *allDatas;

@property (nonatomic, strong) NSString              *maxid;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation SinarioMasterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.isOpen = YES;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getnlInfo)];
    
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
    [self getnlInfo];
}


//数据请求
- (void)getnlInfo {
    
    [MHttpTool postWithURL:NITGetSPList params:nil success:^(id json) {
        
        
        
        [self.tableView.mj_header endRefreshing];
        
        self.maxid = [json objectForKey:@"maxprotoid"];
        if (self.maxid.length > 0) {
            
            [self.addButton setEnabled:YES];
            
            [self.addButton setBackgroundColor:NITColor(243, 85, 115)];
            
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

//tableviewcell点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isOpen = YES;
    [self performSegueWithIdentifier:@"pushEditSinarioMaster" sender:self];
}

- (IBAction)addEditSinarioMaster:(UIButton *)sender {
    self.isOpen = NO;
    [self performSegueWithIdentifier:@"pushEditSinarioMaster" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    EditSinarioController *esc = segue.destinationViewController;
    
    
    
    if (self.isOpen) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        esc.labelTitle = @"詳細";
        esc.isEdit = YES;
        esc.maxid = [self.allDatas[indexPath.row] objectForKey:@"protoid"];
        
    } else {
        esc.labelTitle = @"新规追加";
        esc.isEdit = NO;
        esc.maxid = self.maxid;
        
    }
}
@end
