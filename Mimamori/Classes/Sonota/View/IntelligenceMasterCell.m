//
//  IntelligenceMasterCell.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "IntelligenceMasterCell.h"

@interface IntelligenceMasterCell ()
@property (strong, nonatomic) IBOutlet UITextField *igTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *yiniText;

@property (strong, nonatomic) IBOutlet UITextField *igName;
@property (strong, nonatomic) IBOutlet UITextField *igNameMemo;

@end


@implementation IntelligenceMasterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



/**
 配列コピー
 */
- (void)setDatasDic:(NSDictionary *)datasDic {
    
    _datasDic=datasDic;
    
    //コントロールの編集状態、背景色
    if (self.editOp) {
        
        [self.igTextLabel setEnabled:YES];
        [self.yiniText setEnabled:YES];
        [self.igName setEnabled:YES];
        [self.igNameMemo setEnabled:YES];
        
        [self.igTextLabel setBackgroundColor:[UIColor whiteColor]];
        [self.yiniText setBackgroundColor:[UIColor whiteColor]];
        [self.igName setBackgroundColor:[UIColor whiteColor]];
        [self.igNameMemo setBackgroundColor:[UIColor whiteColor]];
        
        
    } else {
        [self.igTextLabel setEnabled:NO];
        [self.yiniText setEnabled:NO];
        [self.igName setEnabled:NO];
        [self.igNameMemo setEnabled:NO];
        
        [self.igTextLabel setBackgroundColor:NITColor(235, 235, 241)];
        [self.yiniText setBackgroundColor:NITColor(235, 235, 241)];
        [self.igName setBackgroundColor:NITColor(235, 235, 241)];
        [self.igNameMemo setBackgroundColor:NITColor(235, 235, 241)];
    }
    
    
    self.igTextLabel.text = datasDic[@"cd"];
    self.yiniText.text = datasDic[@"initial"];
    self.igName.text = datasDic[@"name"];
    self.igNameMemo.text = datasDic[@"kana"];
    
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField setBackgroundColor:NITColor(253, 164, 181)];
    
    return YES;
}



/**
 編集が終わり
 */
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setBackgroundColor:[UIColor whiteColor]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"COMPANYINFO"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:array[self.cellindex]];
    
    switch (textField.tag) {
        case 1:
            [dic setObject:textField.text forKey:@"cd"];
            break;
        case 2:
            [dic setObject:textField.text forKey:@"initial"];
            break;
        case 3:
            [dic setObject:textField.text forKey:@"name"];
            break;
        case 4:
            [dic setObject:textField.text forKey:@"kana"];
            break;
            
        default:
            break;
    }
    [array replaceObjectAtIndex:self.cellindex withObject:dic];  //この条編集のテキスト欄に入れ替わっ
    [NITUserDefaults setObject:array forKey:@"COMPANYINFO"];
    
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
