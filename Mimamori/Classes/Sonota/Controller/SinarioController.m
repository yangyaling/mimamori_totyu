//
//  SinarioController.m
//  Mimamori
//
//  Created by NISSAY IT on 2016/12/14.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "SinarioController.h"

#import "NITPicker.h"

#import "SinarioTableViewCell.h"

#import "Device.h"


/**
 その他＞見守り設定>個別入居者＞シナリオ＞シナリオ詳細/追加画面のコントローラ
 */
@interface SinarioController ()<MyPickerDelegate>

@property (strong, nonatomic) IBOutlet UITextField         *sinarioText;

@property (strong, nonatomic) IBOutlet UIButton            *sinariobutton;

@property (strong, nonatomic) IBOutlet UITableView         *tableView;

@property (nonatomic, strong) NITPicker                    *picker;  //セレクタ

@property (nonatomic, strong) NSMutableArray               *allarray;

@property (nonatomic, assign) BOOL                         isSelectModelScenario; //雛形(yes - no)


@property (strong, nonatomic) IBOutlet UIButton            *leftTimeButton;

@property (strong, nonatomic) IBOutlet UIButton            *rightTimeButton;

@property (strong, nonatomic) IBOutlet UISegmentedControl  *daySegment;

@property (nonatomic, assign) NSInteger                    timeIndex;   //時間帯(0、1、2、3...)

@property (nonatomic, strong) NSArray                      *modelsArray;  //model datas

@property (nonatomic, assign) NSInteger                    modelindex;   //雛形マーク

@property (nonatomic, assign) BOOL                         isAddCell;    //追加cell状態レコード

@property (strong, nonatomic) IBOutlet UIView              *footView;

@end


@implementation SinarioController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.isAddCell = NO;
    
    
    self.isSelectModelScenario = NO;
    
    self.sinarioText.text = self.textname;
    
    
    self.daySegment.selectedSegmentIndex = self.scopecd;
    
    
    self.timeIndex = self.scopecd;
    
    
    
    [self.leftTimeButton setTitle:(self.starttime.length > 0 ? self.starttime : @"- -") forState:UIControlStateNormal];
        
    [self.rightTimeButton setTitle:(self.endtime.length >0 ? self.endtime : @"- -") forState:UIControlStateNormal];
    
    
     //一覧
    if (self.hideBarButton) {
        
        [self.daySegment setEnabled:NO];
        
        [self.sinarioText setEnabled:NO];
        
        [self.sinariobutton setEnabled:NO];
        
        self.footView.height = 0;
        
        self.footView.alpha = 0;
        
        [self.tableView setEditing:NO];
        
    } else {// 編集
        
        [self.daySegment setEnabled:YES];
        
        [self.sinarioText setEnabled:YES];
        
        [self.sinariobutton setEnabled:YES];
        
        self.footView.height = 100;
        
        self.footView.alpha = 1;
        
    }
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getScenariodtlInfo)];
    
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.tableView.mj_header];
    
    
}

//時間帯ボタンの状態
- (IBAction)selectedTimeButton:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex != 4) {
        [self.leftTimeButton setEnabled:NO];
        [self.rightTimeButton setEnabled:NO];
        self.leftTimeButton.backgroundColor = TextFieldNormalColor;
        self.rightTimeButton.backgroundColor = TextFieldNormalColor;
    }
    
    [self selectedTimeButtonIndex:sender.selectedSegmentIndex];
    
}

//時間帯の選択
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

//その他時間帯のボタン
- (IBAction)timeButtonClick:(UIButton *)sender {
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:nil cellNumber:0];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
}


/**
 シナリオ データ取得
 */
-(void)getScenariodtlInfo{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    
    parametersDict[@"roomid"] = self.roomID;
    parametersDict[@"custid"] = self.user0;
    parametersDict[@"staffid"] = [NITUserDefaults objectForKey:@"userid1"];
    parametersDict[@"facilitycd"] = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    
    if (self.isRefresh) {
        parametersDict[@"scenarioid"] = self.scenarioID;
    }
    
    [MHttpTool postWithURL:NITGetScenarioInfo params:parametersDict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSArray *tmpArr = [json objectForKey:@"scenariodtlinfo"];
        NSArray *tmpModelArr = [json objectForKey:@"protoinfo"];
        
        self.modelsArray = nil;
        if (tmpModelArr.count > 0) {
            
            self.modelsArray = tmpModelArr.copy;
        }
        
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        
        if (tmpArr.count > 0) {
            
            if (self.isSelectModelScenario) {
                
                
                NSInteger arcModelNo = self.modelindex;
                
                NSArray *oldarr = nil;
                
                NSInteger deleteindex = 0;
                
                /**nodeid  マッチング雛形 */
                for (int i = 0 ; i < tmpArr.count ; i++) {
                    NSArray *arr = tmpArr[i];
                    NSInteger newnodetype = [[[tmpModelArr[arcModelNo] firstObject] objectForKey:@"nodetype"] integerValue];
                    NSInteger oldnodetype = [[arr.firstObject objectForKey:@"nodetype"] integerValue];
                    if (oldnodetype == newnodetype) {
                        deleteindex = i;
                        oldarr = arr.copy;
                        break;
                    }
                }
                
                NSInteger scope = [[[tmpModelArr[arcModelNo] firstObject] objectForKey:@"scopecd"] integerValue];
                
                self.timeIndex = scope;
                
                if (self.timeIndex == 4) {
                    
                    [self.leftTimeButton setEnabled:YES];
                    
                    [self.rightTimeButton setEnabled:YES];
                }
                self.daySegment.selectedSegmentIndex = scope;
                
                [self.leftTimeButton setTitle:[[tmpModelArr[arcModelNo] firstObject] objectForKey:@"starttime"] forState:UIControlStateNormal];
                
                [self.rightTimeButton setTitle:[[tmpModelArr[arcModelNo] firstObject] objectForKey:@"endtime"] forState:UIControlStateNormal];
                
                if (tmpModelArr.count == 0) return ; //雛形datas
                
                if (oldarr.count == 0) {
                    [MBProgressHUD showError:@""];
                    return;
                }
              
                NSArray *allarr = [self ScenarioModelDatasUpdate:oldarr andNewArray:tmpModelArr[arcModelNo]];
                
                if (allarr.count == 0) return;
                
                NSMutableArray *reparr = [NSMutableArray arrayWithArray:tmpArr.mutableCopy];
                
                [reparr replaceObjectAtIndex:deleteindex withObject:allarr];
                
                [self.allarray removeAllObjects];
                
                self.allarray = [NSMutableArray arrayWithArray:reparr.mutableCopy];
                
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:reparr];
                
                [NITUserDefaults setObject:data forKey:@"scenariodtlinfoarr"];
                
                
            } else {
                
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:tmpArr];
                
                [NITUserDefaults setObject:data forKey:@"scenariodtlinfoarr"];
                
                self.allarray = [NSMutableArray arrayWithArray:tmpArr];
            }
            
            NSArray *nodes =  [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"addnodeiddatas"]]];
            
            if (nodes.count > 0) {
                
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:nodes];
                
                [NITUserDefaults setObject:data forKey:@"tempdeaddnodeiddatas"];
            }
            
            [self.tableView reloadData];
            
        } else {
            
            [MBProgressHUD showError:@""];
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


/**
 マッチング選択の雛形データ
 */
- (NSArray *)ScenarioModelDatasUpdate:(NSArray *)oldarray andNewArray:(NSArray *)newarray {
    
    if (oldarray.count == 0) {
        
        [MBProgressHUD showError:@""];
        
        return nil;
    }
    
    NSMutableArray *allarr = [NSMutableArray new];
    
    
    //雛形データ挿入
    for (NSDictionary *obj in oldarray) {
        
        NSMutableDictionary *tempdic = [NSMutableDictionary dictionaryWithDictionary:obj];
        
        [tempdic setObject:@"1" forKey:@"detailno"];  //detailno (1.表示)  （0.隠す）
        
        for (NSDictionary *dic in newarray) {
            
           
            [tempdic setObject:dic[@"nodetype"] forKey:@"nodetype"];
            [tempdic setObject:dic[@"endtime"] forKey:@"endtime"];
            [tempdic setObject:dic[@"starttime"] forKey:@"starttime"];
            
            if ([tempdic[@"devicetype"] integerValue] >= 4 && [dic[@"devicetype"] integerValue] >= 4) {
                [tempdic setObject:dic[@"time"] forKey:@"time"];
                [tempdic setObject:@"0" forKey:@"value"];
                [tempdic setObject:dic[@"rpoint"] forKey:@"rpoint"];
                [tempdic setObject:dic[@"devicetype"] forKey:@"devicetype"];
            } else {
                if ([tempdic[@"devicetype"] integerValue] == [dic[@"devicetype"] integerValue]) {
                    
                    [tempdic setObject:dic[@"value"] forKey:@"value"];
                    
                    [tempdic setObject:dic[@"rpoint"] forKey:@"rpoint"];
                    
                    [tempdic setObject:dic[@"time"] forKey:@"time"];
                    
                }
            }
           
        }
        
        [allarr addObject:tempdic];
    }
    
    return allarr;
    
}


#pragma mark - Picker - Delegate
/**
 PickerDelegate
 */
- (void)PickerDelegateSelectString:(NSString *)sinario withDic:(NSDictionary *)addcell {
    
    if (self.isAddCell == NO) {
    
        self.modelindex = [sinario integerValue];
        
        self.sinarioText.text = addcell[@"protoname"];
        
        self.isRefresh = NO;
        
        self.isSelectModelScenario = YES;
        
        [self.tableView.mj_header beginRefreshing];
        
    } else {
        
        NSInteger index = [addcell[@"idx"] integerValue];
        
        NSData *data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        
        
        
        //セル 追加する
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
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        //更新は操作のセル
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation  :UITableViewRowAnimationNone];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }

    
   [CATransaction setCompletionBlock:^{
       [self.tableView reloadData];
   }];
    
}

- (IBAction)PickShow:(UIButton *)sender {
    if (self.modelsArray.count >0) {
        
        self.isAddCell = NO;
        
        _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:self.modelsArray cellNumber:0];
        
        _picker.mydelegate = self;
        
        [WindowView addSubview:_picker];
    } else {
        NITLog(@"雏形数组空");
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSData *data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
    
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return arr.count;
    
}



/**
  セルを値渡す
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SinarioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SinarioTableViewCell" forIndexPath:indexPath];
    
    NSData *data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
    
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.allarray = [NSMutableArray arrayWithArray:arr];
    
    
    cell.cellindex = indexPath.row;
    
    cell.cellarr = self.allarray[indexPath.row];
    
    if (_hideBarButton) {
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
    
}

/**
 追加セル
 */
- (IBAction)addCell:(UIButton *)sender {
    
    NSArray *array = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"tempdeaddnodeiddatas"]]];
    NSData *data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    if (array.count > arr.count) {
        [MBProgressHUD showError:@""];
        return;
    }
    
    if (array.count != 0) {
        
        self.isAddCell = YES;
        
        _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:nil cellNumber:0];
        
        _picker.mydelegate = self;
        
        [WindowView addSubview:_picker];
        
    } else {
        
        [MBProgressHUD showError:@""];
    }
}


/**
   
 チェック  データは完全に記入しているかどうか

 */
- (IBAction)saveScenario:(UIButton *)sender {
    
    NSMutableArray *alldatas = [NSMutableArray new];
    NSData * data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
    NSArray * scenarioarr = [[NSKeyedUnarchiver unarchiveObjectWithData:data] copy];
    
    
    
    for (NSArray *tmparr in scenarioarr) {
        NSMutableArray *array = [NSMutableArray new];
        if (tmparr.count < 4) {
            alldatas = [NSMutableArray new];
            break;
        }
        NSDictionary *dicOne = tmparr[0];
        NSDictionary *dicTwo = tmparr[1];
        NSDictionary *dicThree = tmparr[2];
        NSDictionary *dicFour = tmparr[3];
        if ([dicOne[@"detailno"] integerValue] == 0 && [dicTwo[@"detailno"] integerValue] == 0 && [dicThree[@"detailno"] integerValue] == 0 && [dicFour[@"detailno"] integerValue] == 0){
            continue;
        }
        
        
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
            
            [self updateScenarioInfo:alldatas];
            
            [MBProgressHUD showMessage:@"" toView:self.view];
            
        }else{
            [MBProgressHUD  showError:@"入力項目をチェックしてください!"];
        }
    }
    
}



/**
 *   シナリオ  update
 */
-(void)updateScenarioInfo:(NSArray *)array{
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    
    parametersDict[@"staffid"] = [NITUserDefaults objectForKey:@"userid1"];
    
    parametersDict[@"custid"] = self.user0;
    
    parametersDict[@"scenarioid"] = self.scenarioID;
    
    parametersDict[@"scenarioname"] = self.sinarioText.text;
    
    parametersDict[@"updatedate"] = [[NSDate date]needDateStatus:HaveHMSType];
    
    parametersDict[@"scopecd"] = [NSString stringWithFormat:@"%ld",self.timeIndex];
    
    NSString *startstr = [NSString stringWithFormat:@"%@",self.leftTimeButton.titleLabel.text];
    NSString *endstr = [NSString stringWithFormat:@"%@",self.rightTimeButton.titleLabel.text];
    
    
    if ([startstr isEqualToString:@"- -"] && [endstr isEqualToString:@"- -"]) {
        parametersDict[@"starttime"] = @"00:00:00";
        parametersDict[@"endtime"] = @"00:00:00";
    }else if ([startstr isEqualToString:@"- -"]) {
        parametersDict[@"starttime"] = @"00:00:00";
        parametersDict[@"endtime"] = endstr;
    }else if ([endstr isEqualToString:@"- -"]) {
        parametersDict[@"starttime"] = startstr;
        parametersDict[@"endtime"] = @"00:00:00";
    } else {
        parametersDict[@"starttime"] =startstr;
        parametersDict[@"endtime"] = endstr;
    }
    
    
    NSError *parseError = nil;
    NSData  *json = [NSJSONSerialization dataWithJSONObject:array options: NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    parametersDict[@"scenariodtlinfo"] = str;
    
    //更新データ
    [MHttpTool postWithURL:NITUpdateScenarioInfo params:parametersDict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        
        
        
        NITLog(@"%ld",[[json objectForKey:@"result"] integerValue]);
        
        if ([[json valueForKey:@"code"]isEqualToString:@"200"]) {
            
            if (self.isRefresh) {
                [MBProgressHUD showSuccess:@"更新いたしました"];
            }else {
                [MBProgressHUD showSuccess:@"追加いたしました"];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
                if ([[json objectForKey:@"result"] integerValue] == 0) {
                    if ([self.delegate respondsToSelector:@selector(warningScenarioAddedShow:)]) {
                        NSString *message = [NSString stringWithFormat:@"<センサー> %@%@",self.user0name,_sinarioText.text];
                        
                        //緊急のお知らせをする
                        [self.delegate warningScenarioAddedShow:message];
                    }
                    
                }
                
            });
            
        } else {
            [MBProgressHUD showError:@"後ほど試してください"];
        }
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
    if (!_hideBarButton) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
    
}

/**
 削除セル
 */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        NSData *data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        NSArray *deletearr = array[indexPath.row];
        
        
        NSMutableArray *disparray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData: [NITUserDefaults objectForKey:@"tempdeaddnodeiddatas"]]];
        NSString *disstr = [deletearr.firstObject objectForKey:@"displayname"];
        NSDictionary *disdic = @{@"displayname":disstr,@"idx":@(indexPath.row)};
        [disparray insertObject:disdic atIndex:0];
        
        NSData * datas = [NSKeyedArchiver archivedDataWithRootObject:disparray];
        
        [NITUserDefaults setObject:datas forKey:@"tempdeaddnodeiddatas"];
        
        
        NSMutableArray *newarr = [NSMutableArray new];
        for (int i = 0; i< deletearr.count; i++) {
            NSMutableDictionary *dicOne = [NSMutableDictionary dictionaryWithDictionary:deletearr[i]];
            [dicOne setObject:@"0" forKey:@"detailno"];
            [newarr addObject:dicOne];
        }
        
        
        [array replaceObjectAtIndex:indexPath.row withObject:newarr];
        NSData *newdata = [NSKeyedArchiver archivedDataWithRootObject:array];
        [NITUserDefaults setObject:newdata forKey:@"scenariodtlinfoarr"];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
    }];
}




/**
 使用状態によって表示セルの高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSData *data = [NITUserDefaults objectForKey:@"scenariodtlinfoarr"];
    
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    NSArray *cellarr = arr[indexPath.row];
    
    if (cellarr.count != 4) return 0;
    
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

@end
