//
//  PlaceSettingCell.m
//  Mimamori2
//
//  Created by totyu2 on 2017/4/28.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "PlaceSettingCell.h"

@interface PlaceSettingCell ()

@end

@implementation PlaceSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setDatasDic:(NSDictionary *)datasDic {
    
    _datasDic=datasDic;

    // 編集
    if (self.editOp) {
        [self.numCd setEnabled:YES];
        [self.cdName setEnabled:YES];
        
        [self.numCd setBackgroundColor:[UIColor whiteColor]];
        [self.cdName setBackgroundColor:[UIColor whiteColor]];

    // 表示
    } else {
        [self.numCd setEnabled:NO];
        [self.cdName setEnabled:NO];
        
        [self.numCd setBackgroundColor:TextFieldNormalColor];
        [self.cdName setBackgroundColor:TextFieldNormalColor];
        
    }
    
    // コード編集不可
    NSString *cd = datasDic[@"cd"];
    if (cd.length) {
        [self.numCd setEnabled:NO];
        [self.numCd setBackgroundColor:TextFieldNormalColor];
    }
    
    self.numCd.text = datasDic[@"cd"];
    self.cdName.text = datasDic[@"name"];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField setBackgroundColor:TextFieldNormalColor];
    
    return YES;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setBackgroundColor:[UIColor whiteColor]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"NLINFO"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:array[self.cellindex]];
    if (textField.tag == 1) {
        
        [dic setObject:textField.text forKey:@"cd"];
        
    } else {
        
        [dic setObject:textField.text forKey:@"name"];
    }
    [array replaceObjectAtIndex:self.cellindex withObject:dic];
    [NITUserDefaults setObject:array forKey:@"NLINFO"];
    
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
