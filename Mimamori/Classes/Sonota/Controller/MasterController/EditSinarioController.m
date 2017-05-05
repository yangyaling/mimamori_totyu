//
//  EditSinarioController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#define SINANIOKEY @"EDITSINARIOINFO"
//#define SINARIOADDKEY @"ADDEDITSINARIOINFO"

#import "EditSinarioController.h"
#import "NITPickerTemp.h"
@interface EditSinarioController ()<MyPickerDelegate>
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

@property (strong, nonatomic) IBOutlet UITextField         *ariText;

@property (nonatomic, assign) NSInteger                    timeIndex;

@property (strong, nonatomic) IBOutlet UILabel *lastLabel;

@property (nonatomic, strong) NSMutableArray                    *allarrays;
@end

@implementation EditSinarioController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cxID.text = self.maxid;
    
    self.titleView.text = self.labelTitle;
    self.leftTimeButton.layer.borderWidth = 0.6;
    self.rightTimeButton.layer.borderWidth = 0.6;
    self.leftTimeButton.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.rightTimeButton.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.leftTimeButton.backgroundColor = NITColorAlpha(244, 244, 244, 0.5);
    self.rightTimeButton.backgroundColor = NITColorAlpha(244, 244, 244, 0.5);
    
    
    if (self.isEdit) {
        self.isOpen = NO;
        [self.settingBGView setHidden:YES];
        [self.footerView setHidden:YES];
        [self.signLabel setHidden:NO];
        
        [self buttonStatus:NO withColor:NITColor(235, 235, 241)];
    } else {
        //追加进来
        self.isOpen = YES;
        [self.signLabel setHidden:YES];
        [self.editButton setHidden:YES];
        [self.sinarioName setEnabled:YES];
        [self.ariText setEnabled:YES];
        
        [self buttonStatus:YES withColor:[UIColor whiteColor]];
    }
    
    [self getnlInfo];
    
    NSArray *arr = nil;
    [NITUserDefaults setObject:arr forKey:SINANIOKEY];
    
}


//数据请求
- (void)getnlInfo {
    
    NSDictionary *dic = @{@"protoid":self.maxid};
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    [MHttpTool postWithURL:NITGetSPInfo params:dic success:^(id json) {
        
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        
//        if (self.isEdit) {
            NSArray *tmpArr = [json objectForKey:@"splist"];
            NSDictionary *dicOne = tmpArr.firstObject;
        
            NSArray *scopecdarr = @[@"なし",@"朝方",@"日中",@"夜間",@"その他"];
        
            self.signLabel.text = scopecdarr[[[json objectForKey:@"scopecd"] integerValue]];
        
            self.mySegment.selectedSegmentIndex = [[json objectForKey:@"scopecd"] integerValue];
        
            [self selectedTimeButtonIndex:[[json objectForKey:@"scopecd"] integerValue]];

 
            self.sinarioName.text = [json objectForKey:@"protoname"];
        

            self.ariText.text = [NSString stringWithFormat:@"%@", dicOne[@"nodetype"]];
        
        
        
            if (tmpArr.count >0) {
                
                for (NSDictionary *dic in tmpArr) {
                    
                    if ([dic[@"devicetype"] integerValue] == 1) {
                        //温度
                        NSString *strT1 = [NSString stringWithFormat:@"%@H",dic[@"time"]];
                        
                        NSString *strV1 = [NSString stringWithFormat:@"%@%@%@",dic[@"value"],@"℃",dic[@"rpoint"]];
                        [self.wdButton1 setTitle:strT1 forState:UIControlStateNormal];
                        [self.wdButton2 setTitle:strV1 forState:UIControlStateNormal];
                    } else if ([dic[@"devicetype"] integerValue] == 2) {
                        //湿度
                        NSString *strT2 = [NSString stringWithFormat:@"%@H",dic[@"time"]];
                        NSString *strV2 = [NSString stringWithFormat:@"%@%@%@",dic[@"value"],@"%",dic[@"rpoint"]];
                        [self.sdButton1 setTitle:strT2 forState:UIControlStateNormal];
                        [self.sdButton2 setTitle:strV2 forState:UIControlStateNormal];
                    }else if ([dic[@"devicetype"] integerValue] == 3) {
                        //照明
                        NSString *strT3 = [NSString stringWithFormat:@"%@H",dic[@"time"]];
                        NSString *strV3 = [NSString stringWithFormat:@"%@%@%@",dic[@"value"],@"%",dic[@"rpoint"]];
                        [self.zmButton1 setTitle:strT3 forState:UIControlStateNormal];
                        [self.zmButton2 setTitle:strV3 forState:UIControlStateNormal];
                    }else if ([dic[@"devicetype"] integerValue] == 4) {
                        // 人感
                        NSString *strT4 = [NSString stringWithFormat:@"%@H",dic[@"time"]];
                        NSString *strV4 = [NSString stringWithFormat:@"%@",dic[@"rpoint"]];
                        [self.rgButton1 setTitle:strT4 forState:UIControlStateNormal];
                        [self.rgButton2 setTitle:strV4 forState:UIControlStateNormal];
                    }else {
                        self.lastLabel.text = @"開閉";
                        // 门
                        NSString *strT4 = [NSString stringWithFormat:@"%@H",dic[@"time"]];
                        NSString *strV4 = [NSString stringWithFormat:@"%@",dic[@"rpoint"]];
                        [self.rgButton1 setTitle:strT4 forState:UIControlStateNormal];
                        [self.rgButton2 setTitle:strV4 forState:UIControlStateNormal];
                        
                    }
                }
                
                
                
            }
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:tmpArr];
            
            [NITUserDefaults setObject:data forKey:SINANIOKEY];
            
            [self.tableView reloadData];
            
//        } else {
        
            
//        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        NITLog(@"%@",error);
    }];
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
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
    if ([self.ariText.text isEqualToString:@"2"]) {
        _picker = [[NITPickerTemp alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender cellNumber:2];
    } else {
        _picker = [[NITPickerTemp alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender cellNumber:1];
    }
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
}

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
        [self.ariText setEnabled:YES];
        
        [self buttonStatus:YES withColor:[UIColor whiteColor]];
        //进入编辑状态
        //        [self.tableView setEditing:YES animated:YES];///////////
    }else{
        [sender setTitle:@"編集" forState:UIControlStateNormal];
        self.isOpen = NO;
        [self.signLabel setHidden:NO];
        [self.footerView setHidden:YES];
        [self.settingBGView setHidden:YES];
        [self buttonStatus:NO withColor:NITColor(235, 235, 241)];
        
        [self.sinarioName setEnabled:NO];
        [self.ariText setEnabled:NO];
        
        
        
        [self saveInfo:nil]; //
        
        //取消编辑状态
        //        [self.tableView setEditing:NO animated:YES];/
        
    }
    [self.tableView reloadData];
//    [CATransaction setCompletionBlock:^{
//        
//    }];
}
- (IBAction)selectIndexTime:(UISegmentedControl *)sender {
    self.timeIndex = sender.selectedSegmentIndex;
}

- (IBAction)saveInfo:(UIButton *)sender {
    
    NSMutableArray *tmparray = [self saveScenario]; //本地检测是否 - -
    [tmparray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:obj];
        [dict setObject:self.ariText.text forKey:@"nodetype"];
        if ([self.ariText.text isEqualToString:@"2"]) {
            if ([dict[@"devicetype"] isEqualToString:@"4"]) {
                [dict setObject:@"5" forKey:@"devicetype"];
            }
        }
        [tmparray replaceObjectAtIndex:idx withObject:dict];
    }];
    
    if (tmparray.count == 0) return;
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    NSMutableDictionary *tmpdic = [NSMutableDictionary new];
    tmpdic[@"protoid"] = self.cxID.text;
    tmpdic[@"protoname"] = self.sinarioName.text;
    tmpdic[@"scopecd"] = [NSString stringWithFormat:@"%ld",self.timeIndex];
    
    
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
            [self.tableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        //        [self.tableView setEditing:NO animated:YES];
        NITLog(@"%@",error);
    }];
    
}

/**
 
 保存-遍历检查scenario数据是否填写完整
 
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
    
//    if ([alldatas.firstObject count] > 0) {
//        NITLog(@"%ld",alldatas.count);
        // 网络请求，追加或更新
        //            [MBProgressHUD showError:@"シナリオネームを入力してください"];
        
//        self.allarrays = alldatas.mutableCopy;
        
//        [self saveInfo:nil];
    
        
//    }else{
//        return alldatas;
//        [MBProgressHUD  showError:@"入力項目をチェックしてください!"];
//    }
//    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField setBackgroundColor:NITColor(253, 164, 181)];
    
    return YES;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *startstr = [NSString stringWithFormat:@"%@:00",self.leftTimeButton.titleLabel.text];
    NSString *endstr = [NSString stringWithFormat:@"%@:00",self.rightTimeButton.titleLabel.text];
    NITLog(@"%@-%@",startstr,endstr);
    
    [textField setBackgroundColor:[UIColor whiteColor]];
    
    if (textField.tag == 1000) {
        self.lastLabel.text =  [textField.text isEqualToString:@"2"]?@"開閉":@"人感";
    }
    
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
- (IBAction)showScrollView:(UIButton *)sender {
    _picker = [[NITPickerTemp alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender cellNumber:90];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
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
