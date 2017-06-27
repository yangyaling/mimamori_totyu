//
//  UserMasterCell.m
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/2.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import "UserMasterCell.h"
#import "NITPicker.h"

@interface UserMasterCell ()<MyPickerDelegate>{
    NSString *usertype;
}
@property (strong, nonatomic) IBOutlet UITextField *text1;

@property (strong, nonatomic) IBOutlet UIButton    *pickButton;
@property (strong, nonatomic) IBOutlet UITextField *text2;
@property (nonatomic, strong) NITPicker            *picker;

@end


@implementation UserMasterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    usertype = USERTYPE;
}

/**
 配列コピー
 */
- (void)setDatasDic:(NSDictionary *)datasDic {
    
    _datasDic=datasDic;
    
    //権限状態
    if (self.editOp) {
        
        if ([usertype isEqualToString:@"2"]) {
            
            if (![datasDic[@"usertype"] isEqualToString:@"1"]) {
                
                [self statusEdit:YES withColor:[UIColor whiteColor]];
                
            }
            
        } else {
            
            [self statusEdit:YES withColor:[UIColor whiteColor]];
            
        }
        
    } else {
        
        [self statusEdit:NO withColor:TextFieldNormalColor];
        
    }
    
    self.text1.text = datasDic[@"staffid"];
    
    [self.pickButton setTitle:datasDic[@"usertypename"] forState:UIControlStateNormal];
    
    self.text2.text = datasDic[@"nickname"];
    
}

/**
 コントロールの権限状態
 */
- (void)statusEdit:(BOOL)noOp withColor:(UIColor *)color {
    
    if (!usertype.length) return;
    
    if ([usertype isEqualToString:@"3"]) {
        
    } else if ([usertype isEqualToString:@"2"]) {
        
        [self.pickButton setEnabled:noOp];
        
        [self.pickButton setBackgroundColor:color];
        
        [self.text2 setEnabled:noOp];
        
        [self.text2 setBackgroundColor:color];
        
    } else {
        
        [self.pickButton setEnabled:noOp];
        
        [self.pickButton setBackgroundColor:color];
        
        [self.text2 setEnabled:noOp];
        
        [self.text2 setBackgroundColor:color];
        
    }
}

/**
 オプションフレーム
 */
- (IBAction)showPick:(UIButton *)sender {
    
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:nil cellNumber:self.cellindex];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
    
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField setBackgroundColor:NITColor(253, 164, 181)];
    
    return YES;
}


/**
 編集が終わった後に更新してデータを更新する
 */
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setBackgroundColor:[UIColor whiteColor]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"STAFFINFO"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:array[self.cellindex]];
    if (textField.tag == 1) {
        [dic setObject:textField.text forKey:@"staffid"];
    } else {
        [dic setObject:textField.text forKey:@"nickname"];
    }
    
    [array replaceObjectAtIndex:self.cellindex withObject:dic];
    [NITUserDefaults setObject:array forKey:@"STAFFINFO"];
    
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
