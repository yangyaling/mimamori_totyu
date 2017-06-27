//
//  MachineCell.m
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/2.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import "MachineCell.h"
#import "NITPicker.h"

@interface MachineCell ()<MyPickerDelegate>{
    NSString *usertype;
}
@property (weak, nonatomic) IBOutlet UITextField *serialNoTF;
@property (weak, nonatomic) IBOutlet UITextField *sensorIdTF;
@property (weak, nonatomic) IBOutlet UITextField *custIdTF;
@property (weak, nonatomic) IBOutlet UIButton *custIdBtn;

@property (weak, nonatomic) IBOutlet UITextField *custNameTF;
@property (nonatomic, strong) NITPicker            *picker;
@end

@implementation MachineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    usertype = USERTYPE;
}


/**
 配列コピー
 */
- (void)setDatasDic:(NSDictionary *)datasDic {
    
    _datasDic=datasDic;
    
    //権限状態
    if (self.editOp) {
        [self statusEdit:YES withColor:[UIColor whiteColor]];
        
    } else {
        [self statusEdit:NO withColor:TextFieldNormalColor];
    }
    
    NSString *str1 = [NSString stringWithFormat:@"%@", datasDic[@"sensorid"]];
    NSString *str2 = [NSString stringWithFormat:@"%@", datasDic[@"serial"]];
    NSString *str3 = [NSString stringWithFormat:@"%@", datasDic[@"custid"]];
    NSString *str4 = [NSString stringWithFormat:@"%@", datasDic[@"custname"]];
    
    if ([str3 isEqualToString:@""]) {
        [self.custIdBtn setTitle:@"-" forState:UIControlStateNormal];
        self.custNameTF.text = @"- -";
    } else {
        [self.custIdBtn setTitle:str3 forState:UIControlStateNormal];
        self.custNameTF.text = str4;
    }
    self.sensorIdTF.text = str1;
    self.serialNoTF.text = str2;
    
}


/**
 コントロールの権限状態
 */
- (void)statusEdit:(BOOL)noOp withColor:(UIColor *)color {
    if ([usertype isEqualToString:@"3"] || [usertype isEqualToString:@"x"]) {
       
    } else if ([usertype isEqualToString:@"2"]){
        
        [self.sensorIdTF setEnabled:noOp];
        [self.sensorIdTF setBackgroundColor:color];
        [self.custIdBtn setEnabled:noOp];
        [self.custIdBtn setBackgroundColor:color];
        
        [self.custNameTF setEnabled:noOp];
        [self.custNameTF setBackgroundColor:color];
        
        
    } else {
        [self.sensorIdTF setEnabled:noOp];
        [self.sensorIdTF setBackgroundColor:color];
        
        [self.serialNoTF setEnabled:noOp];
        [self.serialNoTF setBackgroundColor:color];
        
        //        [self.custIdTF setEnabled:noOp];
        //        [self.custIdTF setBackgroundColor:color];
        [self.custIdBtn setEnabled:noOp];
        [self.custIdBtn setBackgroundColor:color];
        
        [self.custNameTF setEnabled:noOp];
        [self.custNameTF setBackgroundColor:color];
    }
}



/**
 オプションフレーム
 */
- (IBAction)showPick:(UIButton *)sender {
    [sender setBackgroundColor:NITColor(253, 164, 181)];
    self.serialNoTF.backgroundColor = [UIColor whiteColor];
    self.sensorIdTF.backgroundColor = [UIColor whiteColor];
    
    self.custNameTF.backgroundColor = NITColor(253, 164, 181);
    self.custNameTF.userInteractionEnabled = NO;
    
    
    //初期化オプションフレーム
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:nil cellNumber:self.cellindex];
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
    
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.custIdBtn.backgroundColor = [UIColor whiteColor];
    self.custNameTF.backgroundColor = [UIColor whiteColor];
    [textField setBackgroundColor:TextSelectColor];
    
    return YES;
}


/**
 編集が終わった後に更新してデータを更新する
 */
-(void)textFieldDidEndEditing:(UITextField *)textField
{

    [textField setBackgroundColor:[UIColor whiteColor]];

    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"SENSORINFO"]]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[self.cellindex]];
    switch (textField.tag) {
        case 1:
            [dic setObject:textField.text forKey:@"serial"];
            break;
        case 2:
            [dic setObject:textField.text forKey:@"sensorid"];
            break;
        case 3:
            [dic setObject:textField.text forKey:@"custid"];
            // 获取name
            break;
        case 4:
            [dic setObject:textField.text forKey:@"custname"];
            break;
        default:
            break;
    }

    [arr replaceObjectAtIndex:self.cellindex withObject:dic];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [NITUserDefaults setObject:data forKey:@"SENSORINFO"];
    
}



/**
 //デリゲートの転送
 */
- (void)PickerDelegateSelectString:(NSString *)sinario withDic:(NSDictionary *)addcell{
    
    
    [self.custIdBtn setTitle:sinario forState:UIControlStateNormal];
    
    self.custNameTF.text = addcell[@"custname"];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"SENSORINFO"]]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[self.cellindex]];
    
    [dic setObject:self.sensorIdTF.text  forKey:@"sensorid"];
    
    [dic setObject:sinario  forKey:@"custid"];
    
    if ([addcell[@"custname"] isEqualToString:@"- -"]) {
        [dic setObject:@"" forKey:@"custname"];
    } else {
        [dic setObject:self.custNameTF.text forKey:@"custname"];
    }
    
    
    [arr replaceObjectAtIndex:self.cellindex withObject:dic]; //この条転送のテキスト欄に入れ替わっ
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [NITUserDefaults setObject:data forKey:@"SENSORINFO"];

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
