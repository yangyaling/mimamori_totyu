//
//  EditSinarioController.m
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/2.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#define SINANIOKEY @"EDITSINARIOINFO"
//#define SINARIOADDKEY @"ADDEDITSINARIOINFO"

#import "EditSinarioController.h"
#import "NITPickerTemp.h"

/**
 その他＞管理者機能＞マスター関連>シナリオマスタ＞シナリオ雛形の編集/追加画面のコントローラ
 */
@interface EditSinarioController ()<MyPickerDelegate>{
    NSString *usertype;
}
@property (strong, nonatomic) IBOutlet DropButton          *facilityBtn;

@property (strong, nonatomic) IBOutlet UILabel             *titleView;

@property (strong, nonatomic) IBOutlet UIButton            *editButton;

@property (strong, nonatomic) IBOutlet UIView              *footerView;

@property (strong, nonatomic) IBOutlet UIView              *settingBGView;

@property (strong, nonatomic) IBOutlet UILabel             *signLabel;

@property (nonatomic, strong) NITPickerTemp                *picker;

@property (strong, nonatomic) IBOutlet UISegmentedControl  *mySegment;

@property (nonatomic, assign) BOOL                         isOpen;

@property (strong, nonatomic) IBOutlet UIButton            *leftTimeButton;
@property (strong, nonatomic) IBOutlet UIButton            *rightTimeButton;

//温度-湿度-照明-人感
@property (strong, nonatomic) IBOutlet UIButton            *wdButton1;
@property (strong, nonatomic) IBOutlet UIButton            *wdButton2;
@property (strong, nonatomic) IBOutlet UIButton            *sdButton1;
@property (strong, nonatomic) IBOutlet UIButton            *sdButton2;
@property (strong, nonatomic) IBOutlet UIButton            *zmButton1;
@property (strong, nonatomic) IBOutlet UIButton            *zmButton2;
@property (strong, nonatomic) IBOutlet UIButton            *rgButton1;
@property (strong, nonatomic) IBOutlet UIButton            *rgButton2;

@property (strong, nonatomic) IBOutlet UILabel             *cxID;

@property (strong, nonatomic) IBOutlet UITextField         *sinarioName;

@property (strong, nonatomic) IBOutlet UISegmentedControl  *ariSegment;


@property (nonatomic, assign) NSInteger                    timeIndex; //時間帯 スコープ

@property (strong, nonatomic) IBOutlet UILabel             *lastLabel;

@property (nonatomic, strong) NSMutableArray               *allarrays;  //雛形データ
@end

@implementation EditSinarioController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ariSegment.selectedSegmentIndex = 0;
    
    // 権限
    usertype = USERTYPE;
    if ([usertype isEqualToString:@"1"]) {
        self.editButton.hidden = NO;
    }else{
        self.editButton.hidden = YES;
    }
    
    self.cxID.text = self.maxid;
    
    self.titleView.text = self.labelTitle;
    
    //雛形詳細
    if (self.isEdit) {
        self.isOpen = NO;
        [self.settingBGView setHidden:YES];
        [self.footerView setHidden:YES];
        [self.signLabel setHidden:NO];
        
        [self buttonStatus:NO withColor:NITColor(235, 235, 241)];
        
    } else {//追加
        
        self.isOpen = YES;
        [self.signLabel setHidden:YES];
        [self.editButton setHidden:YES];
        [self.sinarioName setEnabled:YES];
        [self.sinarioName setBackgroundColor:[UIColor whiteColor]];
        [self.ariSegment setEnabled:YES];
        
        [self buttonStatus:YES withColor:[UIColor whiteColor]];
    }
    
    [self getnlInfo];
    
    NSArray *arr = nil;
    
    [NITUserDefaults setObject:arr forKey:SINANIOKEY];
    
}

//情報取得
- (void)getnlInfo {
    
    NSDictionary *dic = @{@"protoid":self.maxid};
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    [MHttpTool postWithURL:NITGetSPInfo params:dic success:^(id json) {
        
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        
        NSArray *tmpArr = [json objectForKey:@"splist"];
        
        NSDictionary *dicOne = tmpArr.firstObject;
        
        NSArray *scopecdarr = @[@"なし",@"朝方",@"日中",@"夜間",@"その他"];
        
        self.signLabel.text = scopecdarr[[[json objectForKey:@"scopecd"] integerValue]];
        
        //時間帯 スコープ
        self.mySegment.selectedSegmentIndex = [[json objectForKey:@"scopecd"] integerValue];
        
        self.timeIndex = self.mySegment.selectedSegmentIndex;
        
        if (self.isEdit) {
            
            NSString *starttime = [NSString stringWithFormat:@"%@",[json[@"starttime"] isEqual:[NSNull null]]  ? @"- -" :json[@"starttime"]];
            NSString *endtime = [NSString stringWithFormat:@"%@",[json[@"endtime"] isEqual:[NSNull null]]  ? @"- -" :json[@"endtime"]];
            
            [self.leftTimeButton setTitle:starttime forState:UIControlStateNormal];
            [self.rightTimeButton setTitle:endtime forState:UIControlStateNormal];
            
            
            self.ariSegment.selectedSegmentIndex = [dicOne[@"nodetype"] integerValue] - 1;
            
            self.sinarioName.text = [json objectForKey:@"protoname"];
            
        } else {
            
            [self selectedTimeButtonIndex:0];
        }
        
            if (tmpArr.count >0) {
                
                for (NSDictionary *dic in tmpArr) {
                    
                    if ([dic[@"devicetype"] integerValue] == 1) {
                        //温度
                        NSString *strT1 = [NSString stringWithFormat:@"%@H",[dic[@"time"] isEqual:[NSNull null]]  ? @"-" :dic[@"time"]];
                        
                        NSString *strV1 = [NSString stringWithFormat:@"%@%@%@",[dic[@"value"] isEqual:[NSNull null]]  ? @"-" :dic[@"value"],@"℃",[dic[@"rpoint"] isEqual:[NSNull null]]  ? @"-" :dic[@"rpoint"]];
                        [self.wdButton1 setTitle:strT1 forState:UIControlStateNormal];
                        [self.wdButton2 setTitle:strV1 forState:UIControlStateNormal];
                    } else if ([dic[@"devicetype"] integerValue] == 2) {
                        //湿度
                        NSString *strT2 = [NSString stringWithFormat:@"%@H",[dic[@"time"] isEqual:[NSNull null]]  ? @"-" :dic[@"time"]];
                        NSString *strV2 = [NSString stringWithFormat:@"%@%@%@",[dic[@"value"] isEqual:[NSNull null]]  ? @"-" :dic[@"value"],@"%",[dic[@"rpoint"] isEqual:[NSNull null]]  ? @"-" :dic[@"rpoint"]];
                        [self.sdButton1 setTitle:strT2 forState:UIControlStateNormal];
                        [self.sdButton2 setTitle:strV2 forState:UIControlStateNormal];
                    }else if ([dic[@"devicetype"] integerValue] == 3) {
                        //照明
                        NSString *strT3 = [NSString stringWithFormat:@"%@H",[dic[@"time"] isEqual:[NSNull null]]  ? @"-" :dic[@"time"]];
                        NSString *strV3 = [NSString stringWithFormat:@"%@%@%@",[dic[@"value"] isEqual:[NSNull null]]  ? @"-" :dic[@"value"],@"%",[dic[@"rpoint"] isEqual:[NSNull null]]  ? @"-" :dic[@"rpoint"]];
                        [self.zmButton1 setTitle:strT3 forState:UIControlStateNormal];
                        [self.zmButton2 setTitle:strV3 forState:UIControlStateNormal];
                    }else if ([dic[@"devicetype"] integerValue] == 4) {
                        // 人感
                        NSString *strT4 = [NSString stringWithFormat:@"%@H",[dic[@"time"] isEqual:[NSNull null]]  ? @"-" :dic[@"time"]];
                        NSString *strV4 = [NSString stringWithFormat:@"%@",[dic[@"rpoint"] isEqual:[NSNull null]]  ? @"-" :dic[@"rpoint"]];
                        [self.rgButton1 setTitle:strT4 forState:UIControlStateNormal];
                        [self.rgButton2 setTitle:strV4 forState:UIControlStateNormal];
                    }else {
                        self.lastLabel.text = @"開閉";
                        // 開閉
                        NSString *strT4 = [NSString stringWithFormat:@"%@H",[dic[@"time"] isEqual:[NSNull null]]  ? @"-" :dic[@"time"]];
                        NSString *strV4 = [NSString stringWithFormat:@"%@",[dic[@"rpoint"] isEqual:[NSNull null]]  ? @"-" :dic[@"rpoint"]];
                        [self.rgButton1 setTitle:strT4 forState:UIControlStateNormal];
                        [self.rgButton2 setTitle:strV4 forState:UIControlStateNormal];
                    }
                }
            }
        
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:tmpArr];
            
            [NITUserDefaults setObject:data forKey:SINANIOKEY];
            
            [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        [MBProgressHUD hideHUDForView:self.view];
        
        NITLog(@"%@",error);
        
    }];
    
}

- (IBAction)ScopeSelectAction:(UISegmentedControl *)sender {
    
    self.lastLabel.text = sender.selectedSegmentIndex == 1 ? @"開閉":@"人感";
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}

//時間帯ボタンの状態
- (IBAction)selectedTimeButton:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex != 4) {
        [self.leftTimeButton setEnabled:NO];
        [self.rightTimeButton setEnabled:NO];
        self.leftTimeButton.backgroundColor = NITColorAlpha(244, 244, 244, 0.5);
        self.rightTimeButton.backgroundColor = NITColorAlpha(244, 244, 244, 0.5);
    }
    
    [self selectedTimeButtonIndex:sender.selectedSegmentIndex];
}


//時間帯 スコープ
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



/**
 picker分類表示
 */
- (IBAction)timeButtonClick:(UIButton *)sender {
    if (self.ariSegment.selectedSegmentIndex == 1) {
        _picker = [[NITPickerTemp alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender cellNumber:2 isBool:NO];
    } else {
        _picker = [[NITPickerTemp alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender cellNumber:1 isBool:NO];
    }
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
}


/**
 編集スイッチ
 */
- (IBAction)editCell:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"編集"]) {
        [sender setTitle:@"完了" forState:UIControlStateNormal];
    
        self.isOpen = YES;
        [self.signLabel setHidden:YES];
        [self.settingBGView setHidden:NO];
        [self.footerView setHidden:NO];
        
        
        [self.leftTimeButton setEnabled:YES];
        [self.rightTimeButton setEnabled:YES];
        
        [self.sinarioName setEnabled:YES];
        [self.ariSegment setEnabled:YES];
        
        [self.sinarioName setBackgroundColor:[UIColor whiteColor]];
        
        [self buttonStatus:YES withColor:[UIColor whiteColor]];
      
    }else{
        [sender setTitle:@"編集" forState:UIControlStateNormal];
        self.isOpen = NO;
        [self.signLabel setHidden:NO];
        [self.footerView setHidden:YES];
        [self.settingBGView setHidden:YES];
        [self buttonStatus:NO withColor:NITColor(235, 235, 241)];
        
        [self.sinarioName setEnabled:NO];
        [self.ariSegment setEnabled:NO];
        
        
        
        [self saveInfo:nil]; //
        
        
    }
    [self.tableView reloadData];
}



/**
雛形データ更新
 */
- (IBAction)saveInfo:(UIButton *)sender {
    NSString *nodetypestr = [NSString stringWithFormat:@"%ld", self.ariSegment.selectedSegmentIndex + 1];
    NSMutableArray *tmparray = [self saveScenario];
    
    //ノードタイプによると， 表示人感 、開閉
    [tmparray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:obj];
        [dict setObject:nodetypestr forKey:@"nodetype"];
        if ([nodetypestr isEqualToString:@"2"]) {
            if ([dict[@"devicetype"] isEqualToString:@"4"]) {
                [dict setObject:@"5" forKey:@"devicetype"];
                [dict setObject:@"使用なし" forKey:@"rpoint"];
            }
        }else {
            if ([dict[@"devicetype"] isEqualToString:@"5"]) {
                [dict setObject:@"4" forKey:@"devicetype"];
                [dict setObject:@"反応なし" forKey:@"rpoint"];
            }
        }
        [tmparray replaceObjectAtIndex:idx withObject:dict];
    }];
    
    if (tmparray.count == 0) {
        [MBProgressHUD showError:@""];
        return;
    }
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    NSMutableDictionary *tmpdic = [NSMutableDictionary new];
    
    tmpdic[@"protoid"] = self.cxID.text;
    
    tmpdic[@"protoname"] = self.sinarioName.text;
    
    tmpdic[@"scopecd"] = [NSString stringWithFormat:@"%ld",(long)self.timeIndex];
    
    
    NSString *startstr = [NSString stringWithFormat:@"%@:00",self.leftTimeButton.titleLabel.text];
    NSString *endstr = [NSString stringWithFormat:@"%@:00",self.rightTimeButton.titleLabel.text];
    
    if (self.timeIndex == 0) {
        tmpdic[@"starttime"] = NULL;
        tmpdic[@"endtime"] = NULL;
    } else {
        tmpdic[@"starttime"] =startstr;
        tmpdic[@"endtime"] = endstr;
    }
    
    NSError *parseError = nil;
    
    NSData  *json = [NSJSONSerialization dataWithJSONObject:tmparray options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    tmpdic[@"splist"] = str;
    
    [MHttpTool postWithURL:NITUpdateSPInfo params:tmpdic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        
        if (json) {
            
            NSString *code = [json objectForKey:@"code"];
            
            NITLog(@"%@",code);
            
            if ([code isEqualToString:@"200"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                
                [MBProgressHUD showError:@""];
                
            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        //        [self.tableView setEditing:NO animated:YES];
        NITLog(@"%@",error);
    }];
    
}


/**
 チェック  すべての雛形データ
 */
- (NSMutableArray *)saveScenario {
    //    BOOL scenariosuccess = YES;
//    self.allarrays = [NSMutableArray new];
    NSMutableArray *alldatas = [NSMutableArray new];
    NSData * data = [NITUserDefaults objectForKey:SINANIOKEY];
    NSArray * scenarioarr = [[NSKeyedUnarchiver unarchiveObjectWithData:data] copy];
    for (id dic in scenarioarr) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString *timestr = [NSString stringWithFormat:@"%@",dic[@"time"]];
        NSString *valuestr = [NSString stringWithFormat:@"%@",dic[@"value"]];
        NSString *rpointstr = [NSString stringWithFormat:@"%@",dic[@"rpoint"]];
        
        if ( ![timestr isEqualToString:@"-"] && ![valuestr isEqualToString:@"-"] && ![rpointstr isEqualToString:@"-"]) {
            if ([rpointstr isEqualToString:@"以上"]||[rpointstr isEqualToString:@"以下"]) {
                [dict setObject:@"3" forKey:@"pattern"];
            }else if([rpointstr isEqualToString:@"使用あり"]||[rpointstr isEqualToString:@"使用なし"]){
                [dict setObject:@"2" forKey:@"pattern"];
            }else if([rpointstr isEqualToString:@"反応あり"]||[rpointstr isEqualToString:@"反応なし"]){
                [dict setObject:@"1" forKey:@"pattern"];
            }
            [alldatas addObject:dict];
        }
    }
    return alldatas;
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField setBackgroundColor:TextSelectColor];
    
    return YES;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [textField setBackgroundColor:[UIColor whiteColor]];
    
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen) {
        
        if (indexPath.row == 2) {
            
            return 90;
            
        } else {
            
            return 40;
        }
        
    } else {
        
        return 40;
    }
    
}

/**
 セレクタ - （人感、開閉）ボタン
 */
- (IBAction)showScrollView:(UIButton *)sender {
    
    BOOL isOn = YES;
    NSString *str = self.rgButton2.titleLabel.text;
    if ([str isEqualToString:@"使用なし"] || [str isEqualToString:@"反応なし"]) {
        isOn = NO;
    }
    
    _picker = [[NITPickerTemp alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender cellNumber:self.ariSegment.selectedSegmentIndex + 1 isBool:isOn];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
}



/**

 */
- (void)PickerDelegateSelectString:(NSString *)sinario withDic:(NSDictionary *)addcell {
    
    [self.rgButton2 setTitle:sinario forState:UIControlStateNormal];
    
    if ([sinario isEqualToString:@"-"]) {
        return;
    }
    
    if ([sinario isEqualToString:@"使用なし"] || [sinario isEqualToString:@"反応なし"]) {
        [self.rgButton1 setTitle:@"-" forState:UIControlStateNormal];
    } else {
        [self.rgButton1 setTitle:@"0H" forState:UIControlStateNormal];
    }
    
}



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

/**
 権限状態 ->画面編集可能状態
 */
-(void)buttonStatus:(BOOL)noOp withColor:(UIColor *)color {
    
    [self.wdButton1 setEnabled:noOp];
    [self.wdButton1 setBackgroundColor:color];
    [self.wdButton2 setEnabled:noOp];
    [self.wdButton2 setBackgroundColor:color];
    
    [self.sdButton1 setEnabled:noOp];
    [self.sdButton1 setBackgroundColor:color];
    [self.sdButton2 setEnabled:noOp];
    [self.sdButton2 setBackgroundColor:color];
    
    [self.zmButton1 setEnabled:noOp];
    [self.zmButton1 setBackgroundColor:color];
    [self.zmButton2 setEnabled:noOp];
    [self.zmButton2 setBackgroundColor:color];
    
    [self.rgButton1 setEnabled:noOp];
    [self.rgButton1 setBackgroundColor:color];
    [self.rgButton2 setEnabled:noOp];
    [self.rgButton2 setBackgroundColor:color];
}

@end
