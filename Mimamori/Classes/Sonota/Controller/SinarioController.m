//
//  SinarioController.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SinarioController.h"


#import "NITPicker.h"
#import "SinarioTableViewCell.h"

#import "Device.h"
#import "ScenarioCellFrame.h"

@interface SinarioController ()<MyPickerDelegate>


@property (strong, nonatomic) IBOutlet UITextField         *sinarioText;

@property (strong, nonatomic) IBOutlet UIButton            *sinariobutton;

@property (strong, nonatomic) IBOutlet UITableView         *tableView;
@property (nonatomic, strong) NITPicker                    *picker;
@property (nonatomic, assign) NSInteger                    cellnum;

@property (nonatomic, strong) NSMutableArray               *allarray;


@property (nonatomic, assign) BOOL                         isSelectModelScenario;
@property (strong, nonatomic) IBOutlet UIButton            *editButton;


@property (strong, nonatomic) IBOutlet UIButton            *leftTimeButton;
@property (strong, nonatomic) IBOutlet UIButton            *rightTimeButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl  *daySegment;

@property (nonatomic, assign) NSInteger                    timeIndex;

@end


@implementation SinarioController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftTimeButton.layer.borderWidth = 0.6;
    self.rightTimeButton.layer.borderWidth = 0.6;
    self.leftTimeButton.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.rightTimeButton.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.leftTimeButton.backgroundColor = NITColorAlpha(244, 244, 244, 0.5);
    self.rightTimeButton.backgroundColor = NITColorAlpha(244, 244, 244, 0.5);
    [self.leftTimeButton setEnabled:NO];
    [self.rightTimeButton setEnabled:NO];
    
    self.cellnum = 0;
    
    self.isSelectModelScenario = NO;  //雏形开关
    
    self.sinarioText.text = self.textname;
    
    NSArray *nodes = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"addnodeiddatas"]]];
    
    if (nodes.count > 0) {
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:nodes];
        
        [NITUserDefaults setObject:data forKey:@"tempdeaddnodeiddatas"];
    }
    
    self.daySegment.selectedSegmentIndex = self.scopecd;
    
    if (self.starttime.length > 0 || self.endtime.length >0) {
        [self.leftTimeButton setTitle:self.starttime forState:UIControlStateNormal];
        [self.rightTimeButton setTitle:self.endtime forState:UIControlStateNormal];
    }
    
    if (self.hideBarButton) {
        [self.daySegment setEnabled:NO];
        [self.editButton setHidden:YES];
        [self.sinarioText setUserInteractionEnabled:NO];
        [self.sinariobutton setEnabled:NO];
    }
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getScenariodtlInfo)];
    
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
//    [MBProgressHUD showMessage:@"" toView:self.view];
    
}

//时间段的选择
- (IBAction)selectedTimeButton:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex != 4) {
        [self.leftTimeButton setEnabled:NO];
        [self.rightTimeButton setEnabled:NO];
        self.leftTimeButton.backgroundColor = NITColorAlpha(244, 244, 244, 0.5);
        self.rightTimeButton.backgroundColor = NITColorAlpha(244, 244, 244, 0.5);
    }
    [self selectedTimeButtonIndex:sender.selectedSegmentIndex];
    
    
}

-(void)selectedTimeButtonIndex:(NSInteger)index{
    self.timeIndex = index;
    switch (index) {
        case 0:
            [self.leftTimeButton setTitle:@"- -" forState:UIControlStateNormal];
            [self.rightTimeButton setTitle:@"- -" forState:UIControlStateNormal];
            break;
            
        case 1:
            [self.leftTimeButton setTitle:@"04:00" forState:UIControlStateNormal];
            [self.rightTimeButton setTitle:@"09:00" forState:UIControlStateNormal];
            break;
            
        case 2:
            [self.leftTimeButton setTitle:@"09:00" forState:UIControlStateNormal];
            [self.rightTimeButton setTitle:@"18:00" forState:UIControlStateNormal];
            break;
            
        case 3:
            [self.leftTimeButton setTitle:@"18:00" forState:UIControlStateNormal];
            [self.rightTimeButton setTitle:@"04:00" forState:UIControlStateNormal];
            break;
            
        case 4:
            [self.leftTimeButton setEnabled:YES];
            [self.rightTimeButton setEnabled:YES];
            self.leftTimeButton.backgroundColor = [UIColor whiteColor];
            self.rightTimeButton.backgroundColor = [UIColor whiteColor];
            break;
            
            
        default:
            break;
    }
}

//其他时间的点击弹窗
- (IBAction)timeButtonClick:(UIButton *)sender {
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:self.device cellNumber:0];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}


-(void)getScenariodtlInfo{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    parametersDict[@"roomid"] = self.roomID;
    
    
    if (self.isRefresh) {
        parametersDict[@"scenarioid"] = self.scenarioID;
    }
    
    [MHttpTool postWithURL:NITGetScenarioInfo params:parametersDict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSArray *tmpArr = [json objectForKey:@"scenariodtlinfo"];
        
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        
        if (tmpArr) {
            
            if (self.isSelectModelScenario) {
                
                NSArray *tmpModelArr = [json objectForKey:@"protoinfo"];
                
                NSInteger scope = [[[tmpModelArr[0] firstObject] objectForKey:@"scopecd"] integerValue];
                
                self.timeIndex = scope;
                
                self.daySegment.selectedSegmentIndex = scope;
                
//                [self selectedTimeButtonIndex:scope];
                
                [self.leftTimeButton setTitle:[[tmpModelArr[0] firstObject] objectForKey:@"starttime"] forState:UIControlStateNormal];
                [self.rightTimeButton setTitle:[[tmpModelArr[0] firstObject] objectForKey:@"endtime"] forState:UIControlStateNormal];
                
                int arcModelNo = arc4random() % tmpModelArr.count; //随机选择某个
                
                if (tmpModelArr.count == 0) return ; //雏形数组
                
                NSArray *allarr = [self ScenarioModelDatasUpdate:tmpArr[0] andNewArray:tmpModelArr[arcModelNo]];
                
                NSMutableArray *reparr = [NSMutableArray arrayWithArray:tmpArr.mutableCopy];
                
                [reparr replaceObjectAtIndex:0 withObject:allarr];
                
                if (allarr.count == 0) return;
                
                [self.allarray removeAllObjects];
                
                self.allarray = [NSMutableArray arrayWithArray:reparr.mutableCopy];
                
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:reparr];
                
                [NITUserDefaults setObject:data forKey:@"scenariodtlinfoarr"];
                
                NSArray *nodes =  [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"addnodeiddatas"]]];
                
                if (nodes.count > 0) {
                    
                    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:nodes];
                    
                    [NITUserDefaults setObject:data forKey:@"tempdeaddnodeiddatas"];
                }
                
            } else {
//                NSInteger scope = [[[tmpArr[0] firstObject] objectForKey:@"scopecd"] integerValue];
//                
//                self.daySegment.selectedSegmentIndex = scope;
//                
//                [self selectedTimeButtonIndex:scope];
                
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:tmpArr];
                [NITUserDefaults setObject:data forKey:@"scenariodtlinfoarr"];
                self.allarray = [NSMutableArray arrayWithArray:tmpArr];
                //                                 [NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"scenariodtlinfoarr"]]];
            }
            [self.tableView reloadData];
        }

    } failure:^(NSError *error) {
        
        NITLog(@"%@",error);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [self.tableView.mj_header endRefreshing];
        
        NSArray *arr = nil;
        [NITUserDefaults setObject:arr forKey:@"scenariodtlinfoarr"];
        
        [NITUserDefaults setObject:arr forKey:@"tempdeaddnodeiddatas"];
    }];
    
    
}

- (NSArray *)ScenarioModelDatasUpdate:(NSArray *)oldarray andNewArray:(NSArray *)newarray {
    
    
    NSMutableArray *allarr = [NSMutableArray new];
    for (NSDictionary *obj in oldarray) {
        NSMutableDictionary *tempdic = [NSMutableDictionary dictionaryWithDictionary:obj];
        [tempdic setObject:@"1" forKey:@"detailno"];
        for (NSDictionary *dic in newarray) {
            if ([tempdic[@"nodetype"] integerValue] == 1) {
                if ([tempdic[@"devicetype"] integerValue] == [dic[@"devicetype"] integerValue]) {
                    [tempdic setObject:dic[@"endtime"] forKey:@"endtime"];
                    [tempdic setObject:dic[@"starttime"] forKey:@"starttime"];
                    
                    [tempdic setObject:dic[@"time"] forKey:@"time"];
                    
                    if ([tempdic[@"devicetype"] integerValue] == 4 || [tempdic[@"devicetype"] integerValue] == 5) {
                        [tempdic setObject:@"0" forKey:@"value"];
                    } else {
                        [tempdic setObject:dic[@"value"] forKey:@"value"];
                    }
                    
                    [tempdic setObject:dic[@"rpoint"] forKey:@"rpoint"];
                    
                } else {
                    [tempdic setObject:dic[@"endtime"] forKey:@"endtime"];
                    [tempdic setObject:dic[@"starttime"] forKey:@"starttime"];
                }
            } else {
                if ([tempdic[@"devicetype"] integerValue] == [dic[@"devicetype"] integerValue]) {
                    [tempdic setObject:dic[@"endtime"] forKey:@"endtime"];
                    [tempdic setObject:dic[@"starttime"] forKey:@"starttime"];
                    [tempdic setObject:dic[@"nodetype"] forKey:@"nodetype"];
                    
                    [tempdic setObject:dic[@"time"] forKey:@"time"];
                    if ([tempdic[@"devicetype"] integerValue] == 4 || [tempdic[@"devicetype"] integerValue] == 5) {
                        [tempdic setObject:@"0" forKey:@"value"];
                    } else {
                        [tempdic setObject:dic[@"value"] forKey:@"value"];
                    }
                    [tempdic setObject:dic[@"rpoint"] forKey:@"rpoint"];
                } else {
                    [tempdic setObject:dic[@"endtime"] forKey:@"endtime"];
                    [tempdic setObject:dic[@"starttime"] forKey:@"starttime"];
                }
            }
            
        }
        [allarr addObject:tempdic];
    }
    
    
    return allarr;
}


/**
 PickerDelegate
 */
- (void)PickerDelegateSelectString:(NSString *)sinario withDic:(NSDictionary *)addcell {
    
    if (addcell.count == 0) {
        
        self.sinarioText.text = sinario;
        
        self.isRefresh = NO;
        
        self.isSelectModelScenario = YES;
        
        [self.tableView.mj_header beginRefreshing];
        
    } else {
        NSInteger index = [addcell[@"idx"] integerValue];
        
        
        NSData *data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        
        
        NSArray *deletearr = arr[index];
        NSMutableArray *newarr = [NSMutableArray new];
        for (int i = 0; i< deletearr.count; i++) {
            NSMutableDictionary *dicOne = [NSMutableDictionary dictionaryWithDictionary:deletearr[i]];
            [dicOne setObject:@"1" forKey:@"detailno"];
            [newarr addObject:dicOne];
        }
        [arr replaceObjectAtIndex:index withObject:newarr];
        
        NSData *newdata = [NSKeyedArchiver archivedDataWithRootObject:arr];
        [NITUserDefaults setObject:newdata forKey:@"scenariodtlinfoarr"];
        
        
        //        NSMutableArray *disparray =[NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"tempdeaddnodeiddatas"]];
        //        [disparray removeObject:sinario];
        //        [NITUserDefaults setObject:disparray forKey:@"tempdeaddnodeiddatas"];
        
        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//        //        self.cellnum ++;
//        [self.tableView beginUpdates];
//        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView endUpdates];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation  :UITableViewRowAnimationNone];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        //UITableViewScrollPositionNone
        //UITableViewScrollPositionMiddle
        //UITableViewScrollPositionBottom
        //UITableViewScrollPositionTop
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
    
   [CATransaction setCompletionBlock:^{
       [self.tableView reloadData];
   }];
    
}

- (IBAction)PickShow:(UIButton *)sender {
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:self.device cellNumber:0];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _allarray.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SinarioTableViewCell *cell = [SinarioTableViewCell cellWithTableView:tableView];
    
    NSData *data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
    
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.allarray = [NSMutableArray arrayWithArray:arr];
    
//    self.allarray = [Device mj_objectArrayWithKeyValuesArray:arr.copy];
    
//    if (_allarray.count == 0) return cell;
    
//    Device *devices = self.allarray[indexPath.row];
    
    cell.cellindex = indexPath.row;
    
    cell.cellarr = self.allarray[indexPath.row];
    
    
//    if ([dicOne[@"detailno"] integerValue] == 0 && [dicTwo[@"detailno"] integerValue] == 0 && [dicThree[@"detailno"] integerValue] == 0 && [dicFour[@"detailno"] integerValue] == 0) return cell;
    
    if (self.cellnum == 0) { //cell是否可以编辑
        cell.userInteractionEnabled = NO;
    }
    
    
    return cell;
    
}

//
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width,100)];
//    footerView.backgroundColor = [UIColor redColor];
    
    UIButton *editButton =[[UIButton alloc] initWithFrame:CGRectMake(20, 5, 40, 35)];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(62, 20, self.view.width - 82, 1.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *saveButton =[[UIButton alloc] initWithFrame:CGRectMake(self.view.width *0.2, 45, self.view.width - (self.view.width *0.4), 50)];
    
    
    [editButton setTitle: @"＋" forState: UIControlStateNormal];
    editButton.tag = 11;
    [editButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(addScenarioCell:) forControlEvents:UIControlEventTouchUpInside];
    
    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:36.0];
    editButton.layer.cornerRadius = 5;
    editButton.layer.borderWidth = 1.3;
    editButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [saveButton setTitle: @"登 録" forState: UIControlStateNormal];
    saveButton.backgroundColor = NITColor(252, 85, 115);
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveScenario:) forControlEvents:UIControlEventTouchUpInside];
    
    saveButton.titleLabel.font = [UIFont systemFontOfSize:26.0];
    saveButton.layer.cornerRadius = 5;
    
//    saveButton.layer.borderWidth = 1.3;
//    saveButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [footerView addSubview:editButton];
    
    [footerView addSubview:saveButton];
    
    [footerView addSubview:line];
    
    return footerView;
}


- (void)addScenarioCell:(UIButton *)sender {
    
    NSArray *array = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"tempdeaddnodeiddatas"]]];
    
    if (array.count != 0) {
        
        _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:self.device cellNumber:0];
        
        _picker.mydelegate = self;
        
        [WindowView addSubview:_picker];
        
    } else {
        
        [MBProgressHUD showError:@""];
    }
}

- (IBAction)gobacktoC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


/**
    编辑
 */
- (IBAction)EditBarButton:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"編集"]) {
        [sender setTitle:@"完了" forState:UIControlStateNormal];
        
        self.cellnum = 100;
        
        //进入编辑状态
        [self.tableView setEditing:YES animated:YES];
    }else{
        [sender setTitle:@"編集" forState:UIControlStateNormal];
        
        self.cellnum = 0;
        
        [self saveScenario:nil]; //跟新或者追加
        
        //取消编辑状态
        [self.tableView setEditing:NO animated:YES];
        
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
    }];
    
}



/**
   
     保存-遍历检查scenario数据是否填写完整

 */
- (void)saveScenario:(UIButton *)sender {
//    BOOL scenariosuccess = YES;
    
    NSMutableArray *alldatas = [NSMutableArray new];
    NSData * data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
    NSArray * scenarioarr = [[NSKeyedUnarchiver unarchiveObjectWithData:data] copy];
    for (NSArray *tmparr in scenarioarr) {
        
        NSDictionary *dicOne = tmparr[0];
        NSDictionary *dicTwo = tmparr[1];
        NSDictionary *dicThree = tmparr[2];
        NSDictionary *dicFour = tmparr[3];
        if ([dicOne[@"detailno"] integerValue] == 0 && [dicTwo[@"detailno"] integerValue] == 0 && [dicThree[@"detailno"] integerValue] == 0 && [dicFour[@"detailno"] integerValue] == 0){
            continue;
        }
        NSMutableArray *array = [NSMutableArray new];
        
        NSString *onetime = [NSString stringWithFormat:@"%@",dicOne[@"time"]];
        if (![onetime isEqualToString:@"-"] && ![dicOne[@"rpoint"] isEqualToString:@"-"]) {
            
            [array addObject:dicOne];
        }
        
        NSString *twotime = [NSString stringWithFormat:@"%@",dicTwo[@"time"]];
        NSString *twovalue = [NSString stringWithFormat:@"%@",dicTwo[@"value"]];
        if ( ![twotime isEqualToString:@"-"] && ![twovalue isEqualToString:@"-"] && ![dicTwo[@"rpoint"] isEqualToString:@"-"]) {
            [array addObject:dicTwo];
        }
        
        NSString *threetime = [NSString stringWithFormat:@"%@",dicThree[@"time"]];
        NSString *threevalue = [NSString stringWithFormat:@"%@",dicThree[@"value"]];
        if (![threetime isEqualToString:@"-"] && ![threevalue isEqualToString:@"-"] && ![dicThree[@"rpoint"] isEqualToString:@"-"] ) {
            [array addObject:dicThree];
        }
        
        NSString *fourtime = [NSString stringWithFormat:@"%@",dicFour[@"time"]];
        NSString *fourvalue = [NSString stringWithFormat:@"%@",dicFour[@"value"]];
        if (![fourtime isEqualToString:@"-"] && ![fourvalue isEqualToString:@"-"] && ![dicFour[@"rpoint"] isEqualToString:@"-"]) {
            [array addObject:dicFour];
        }
        [alldatas addObject:array];
    }
    
    if (!self.sinarioText.text.length) {
        [MBProgressHUD showError:@"シナリオネームを入力してください"];
    }else{
        if ([alldatas.firstObject count] > 0) {
            NITLog(@"%ld",alldatas.count);
            // 网络请求，追加或更新
//            [MBProgressHUD showError:@"シナリオネームを入力してください"];
            [self updateScenarioInfo:alldatas];
            [MBProgressHUD showMessage:@"" toView:self.view];
        }else{
            [MBProgressHUD  showError:@"入力項目をチェックしてください!"];
        }
    }
    
}



/**
 *   シナリオ上传到服务器
 */
-(void)updateScenarioInfo:(NSArray *)array{
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    
    parametersDict[@"staffid"] = [NITUserDefaults objectForKey:@"userid1"];
    
    parametersDict[@"custid"] = self.user0;
    
    parametersDict[@"scenarioid"] = self.scenarioID;
    
    parametersDict[@"scenarioname"] = self.sinarioText.text;
    
    parametersDict[@"updatedate"] = [[NSDate date]needDateStatus:HaveHMSType];
    
    parametersDict[@"scopecd"] = [NSString stringWithFormat:@"%ld",self.timeIndex];
    
    
    NSString *startstr = [NSString stringWithFormat:@"%@:00",self.leftTimeButton.titleLabel.text];
    NSString *endstr = [NSString stringWithFormat:@"%@:00",self.rightTimeButton.titleLabel.text];
    
    if (self.timeIndex == 0) {
        parametersDict[@"starttime"] = NULL;
        parametersDict[@"endtime"] = NULL;
    } else {
        parametersDict[@"starttime"] =startstr;
        parametersDict[@"endtime"] = endstr;
    }
    
    //保存detailinfo的数组转换成json数据格式
    NSError *parseError = nil;
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    parametersDict[@"scenariodtlinfo"] = str;
    //
    //NITUpdateScenarioInfo
    [MHttpTool postWithURL:NITUpdateScenarioInfo params:parametersDict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        //追加成功，显示信息
        if ([[json valueForKey:@"code"]isEqualToString:@"200"]) {
            
            if (self.isRefresh) {
                [MBProgressHUD showSuccess:@"更新いたしました"];
            }else {
                [MBProgressHUD showSuccess:@"追加いたしました"];
            }
            //跳转到前页面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
                // 如果刚刚添加的scenario检知到异常
                if ([[json objectForKey:@"result"] integerValue] == 0) {
                    if ([self.delegate respondsToSelector:@selector(warningScenarioAddedShow:)]) {
                        NSString *message = [NSString stringWithFormat:@"<センサー> %@%@",self.user0name,_sinarioText.text];
                        [self.delegate warningScenarioAddedShow:message];
                    }
                    
                }
                
            });
            
        } else {
            [MBProgressHUD showError:@"後ほど試してください"];
        }
        //[2]	(null)	@"message" : @"[Microsoft][ODBC Driver 11 for SQL Server][SQL Server]Error converting data type varchar to float."
        
    } failure:^(NSError *error) {
        
        NITLog(@"%@",error);
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"後ほど試してください"];
        
    }];
    
    
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        NSData *data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        NSArray *deletearr = array[indexPath.row];
        
        //删除一个cell  pick上添加当前删除的displayname
        
        NSMutableArray *disparray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData: [NITUserDefaults objectForKey:@"tempdeaddnodeiddatas"]]];
        NSString *disstr = [deletearr.firstObject objectForKey:@"displayname"];
        NSDictionary *disdic = @{@"displayname":disstr,@"idx":@(indexPath.row)};
        [disparray insertObject:disdic atIndex:0];
        
        NSData * datas = [NSKeyedArchiver archivedDataWithRootObject:disparray];
        
        [NITUserDefaults setObject:datas forKey:@"tempdeaddnodeiddatas"];
        
        
        //删除总数组当行cell的所有数据  再缓存新的临时数组
        NSMutableArray *newarr = [NSMutableArray new];
        for (int i = 0; i< deletearr.count; i++) {
            NSMutableDictionary *dicOne = [NSMutableDictionary dictionaryWithDictionary:deletearr[i]];
            [dicOne setObject:@"0" forKey:@"detailno"];
            [newarr addObject:dicOne];
        }
        
        
        
//        NSMutableDictionary *dicOne = [NSMutableDictionary dictionaryWithDictionary:deletearr.firstObject];
//
//        NSMutableDictionary *dicTwo = [NSMutableDictionary dictionaryWithDictionary:[deletearr objectAtIndex:1]];
//
//        NSMutableDictionary *dicThree = [NSMutableDictionary dictionaryWithDictionary:[deletearr objectAtIndex:2]];
//
//        NSMutableDictionary *dicFour = [NSMutableDictionary dictionaryWithDictionary:deletearr.lastObject];
//        
//        [dicOne setObject:@"0" forKey:@"detailno"];
//        [dicTwo setObject:@"0" forKey:@"detailno"];
//        [dicThree setObject:@"0" forKey:@"detailno"];
//        [dicFour setObject:@"0" forKey:@"detailno"];
//        [deletearr removeAllObjects];
        
        //            if ([dicOne[@"detailno"] integerValue] == 0 && [dicTwo[@"detailno"] integerValue] == 0 && [dicThree[@"detailno"] integerValue] == 0 && [dicFour[@"detailno"] integerValue] == 0) ;
        
        
        [array replaceObjectAtIndex:indexPath.row withObject:newarr];
        NSData *newdata = [NSKeyedArchiver archivedDataWithRootObject:array];
        [NITUserDefaults setObject:newdata forKey:@"scenariodtlinfoarr"];
        
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView beginUpdates];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//        [self.tableView endUpdates];
        
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
    
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
    }];
}




-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return self.cellnum;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSData *data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *cellarr = arr[indexPath.row];
//    ScenarioCellFrame *frame = [[ScenarioCellFrame alloc] init];
//    Device *devi = self.allarray[indexPath.row];
//    frame.scenarioM = devi;
//
    if (cellarr.count == 0) return 0;
    
    NSDictionary *dicOne = cellarr.firstObject;
    
    NSDictionary *dicTwo = [cellarr objectAtIndex:1];
    
    NSDictionary *dicThree = [cellarr objectAtIndex:2];
    
    NSDictionary *dicFour = cellarr.lastObject;
    
    if ([dicOne[@"detailno"] integerValue] == 0 && [dicTwo[@"detailno"] integerValue] == 0 && [dicThree[@"detailno"] integerValue] == 0 && [dicFour[@"detailno"] integerValue] == 0){
        
        return 0;
    } else {
        
        NSMutableArray *tmparray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"tempdeaddnodeiddatas"]]];
        if (tmparray.count > 0) {
            for (NSDictionary *dic in tmparray) {
                if ([dic[@"idx"] integerValue] == indexPath.row) {
                    [tmparray removeObject:dic];
                    break;
                }
            }
        }
        NSData * datas = [NSKeyedArchiver archivedDataWithRootObject:tmparray];
        
        [NITUserDefaults setObject:datas forKey:@"tempdeaddnodeiddatas"];
        return 162;
    }
    
}





#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return  YES;
}

-(NSMutableArray *)allarray {
    if (!_allarray) {
        _allarray = [NSMutableArray array];
    }
    return _allarray;
}




//                NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                //获取完整路径
//                NSString *documentsPath = [path objectAtIndex:0];
//                NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"ScenarioModel.plist"];
//                NSMutableArray *arr = [NSMutableArray new];
//                NSMutableDictionary *usersDic = [[NSMutableDictionary alloc ] init];
//
//                [usersDic setObject:tmpArr[0] forKey:@"ModelOne"];
//                [usersDic setObject:tmpArr[0] forKey:@"ModelTwo"];
//                [usersDic setObject:tmpArr[0] forKey:@"ModelThree"];
//                [arr addObject:usersDic];
//                //写入文件
//                [usersDic writeToFile:plistPath atomically:YES];

@end
