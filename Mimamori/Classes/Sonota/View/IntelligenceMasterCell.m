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

- (void)setDatasDic:(NSDictionary *)datasDic {
    
    _datasDic=datasDic;
    
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
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"COMPANYINFO"]];
    [arr replaceObjectAtIndex:self.cellindex withObject:dic];
    [NITUserDefaults setObject:arr forKey:@"COMPANYINFO"];
    
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
