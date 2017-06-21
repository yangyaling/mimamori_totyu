//
//  IntelligenceController.m
//  Mimamori2
//
//  Created by totyu2 on 2017/4/28.
//  Copyright © 2017年 totyu3. All rights reserved.
//  施設情報

#import "IntelligenceController.h"

@interface IntelligenceController (){
    NSString *usertype;
}
@property (strong, nonatomic) IBOutlet DropButton *facilityBtn;

//基本情報
@property (strong, nonatomic) IBOutlet UITextField *kodoField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;

//施設情報
@property (strong, nonatomic) IBOutlet UITextField *hosutoIdField;
@property (strong, nonatomic) IBOutlet UITextField *facilityField;
@property (strong, nonatomic) IBOutlet UITextField *facilityNameField;
@property (strong, nonatomic) IBOutlet UITextField *fckanaField;
@property (strong, nonatomic) IBOutlet UITextField *facilityName2Field;
@property (strong, nonatomic) IBOutlet UITextField *fckana2Field;

@property (strong, nonatomic) IBOutlet UIButton    *editButton;
@end

@implementation IntelligenceController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    usertype = USERTYPE;
    if ([usertype isEqualToString:@"1"] || [usertype isEqualToString:@"2"]) {
        self.editButton.hidden = NO;
    }else{
        self.editButton.hidden = YES;
    }
    
    [self getinfo];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}

-(void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideHUDForView:self.navigationController.view];
}



/**
 情報取得
 */
- (void)getinfo {
    [MBProgressHUD showMessage:@"" toView:self.navigationController.view];
    NSString *facd = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilitycd"];
    NSDictionary *dic = @{@"facilitycd":facd};
    
    [MHttpTool postWithURL:NITGetFacilityInfo params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        NSDictionary *indoDic = [json objectForKey:@"facilityinfo"];
        if (indoDic.count > 0) {
            self.kodoField.text = indoDic[@"companycd"];
            self.nameField.text = indoDic[@"companyname"];
            
            self.hosutoIdField.text = indoDic[@"hostcd"];
            self.facilityField.text = indoDic[@"facilitycd"];
            self.facilityNameField.text = indoDic[@"facilityname1"];
            self.fckanaField.text = indoDic[@"facilityname1kana"];
            self.facilityName2Field.text = indoDic[@"facilityname2"];
            self.fckana2Field.text = indoDic[@"facilityname2kana"];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        NITLog(@"%@",error);
    }];
    [self.tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    _facilityBtn.buttonTitle = [[NITUserDefaults objectForKey:@"TempFacilityName"] objectForKey:@"facilityname2"];
}


/**
 切替施設
 */
-(void)SelectedListName:(NSDictionary *)clickDic{
    [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
    [self statusEdit:NO withColor:TextFieldNormalColor];
    _facilityBtn.showAlert = NO;
    [self getinfo];
}



/**
 施設名改正後  保存
 */
- (void)AgainFacilityList {
    [MBProgressHUD showMessage:@"" toView:self.navigationController.view];
    NSString *staffid = [NITUserDefaults objectForKey:@"userid1"];
    NSDictionary *dic = @{
                          @"staffid":staffid,
                          
                          @"hostcd":@"host01",
                          
                          };
    [MHttpTool postWithURL:NITGetfacilityList params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        
        NSArray *array = nil;
        
        array = [json objectForKey:@"facilitylist"];
        
        if (array.count > 0) {
            
            NSMutableArray *imags = [NSMutableArray new];
            
            for (int i = 0; i < array.count; i++) {
                [imags addObject:@"space_icon"];
            }
            [NITUserDefaults setObject:imags forKey:@"CellImagesName"];
            [NITUserDefaults synchronize];
            
            [NITUserDefaults setObject:array forKey:@"FacilityList"];
            [NITUserDefaults synchronize];
            
            
            [imags replaceObjectAtIndex:0 withObject:@"selectfacitility_icon"];
            [NITUserDefaults setObject:imags forKey:@"TempcellImagesName"];
            [NITUserDefaults synchronize];
            
            [NITUserDefaults setObject:array[0] forKey:@"TempFacilityName"];
            [NITUserDefaults synchronize];
            
            
        } else {
            [MBProgressHUD showError:@""];
        }
        [CATransaction setCompletionBlock:^{
            [self.tableView reloadData];
        }];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        NITLog(@"%@",error);
    }];
}

- (IBAction)editCell:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"編集"]) {
        
        _facilityBtn.showAlert = YES;
        
        [sender setTitle:@"完了" forState:UIControlStateNormal];
        
        [self statusEdit:YES withColor:[UIColor whiteColor]];
        
    }else{
        
        [self saveInfo]; //跟新或者追加
    }
    
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
    }];
    
}



- (void)statusEdit:(BOOL)noOp withColor:(UIColor *)color {
    
    if ([usertype isEqualToString:@"2"]) {
        [self.facilityName2Field setEnabled:noOp];
        [self.facilityName2Field setBackgroundColor:color];
        [self.fckana2Field setEnabled:noOp];
        [self.fckana2Field setBackgroundColor:color];
    } else {
        [self.facilityName2Field setEnabled:noOp];
        [self.facilityName2Field setBackgroundColor:color];
        [self.fckana2Field setEnabled:noOp];
        [self.fckana2Field setBackgroundColor:color];
        
    }
}


- (void)saveInfo {
    [MBProgressHUD showMessage:@"" toView:self.navigationController.view];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSString *staffid = [NITUserDefaults objectForKey:@"userid1"];
    
    dic[@"companycd"]= self.kodoField.text;
    dic[@"companyname"] = self.nameField.text;
    
    dic[@"hostcd"] = self.hosutoIdField.text;
    
    dic[@"facilitycd"] = self.facilityField.text;
    dic[@"facilityname1"]= self.facilityNameField.text;
    dic[@"facilityname1kana"] = self.fckanaField.text;
    dic[@"facilityname2"]= self.facilityName2Field.text;
    dic[@"facilityname2kana"]= self.fckana2Field.text;
    
    
    NSError *parseError = nil;
    
    NSData  *json = [NSJSONSerialization dataWithJSONObject:dic options: NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    NSDictionary *lastDic = @{
                              @"staffid":staffid,
                              
                              @"facilityinfo":str
                              };
    
    [MHttpTool postWithURL:NITUpdateFacilityInfo params:lastDic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (json) {
            NSString *code = [json objectForKey:@"code"];
            NITLog(@"%@",code);
            if ([code isEqualToString:@"200"]) {
                [self.editButton setTitle:@"編集" forState:UIControlStateNormal];
                [self statusEdit:NO withColor:TextFieldNormalColor];
                [self AgainFacilityList];
                
                
                _facilityBtn.showAlert = NO;
            } else {
                [MBProgressHUD showError:@""];
            }
            
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        NITLog(@"%@",error);
    }];
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField setBackgroundColor:TextSelectColor];
    
    return YES;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setBackgroundColor:[UIColor whiteColor]];
    
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
@end
