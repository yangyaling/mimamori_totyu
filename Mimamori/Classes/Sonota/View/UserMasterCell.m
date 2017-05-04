//
//  UserMasterCell.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "UserMasterCell.h"
#import "NITPicker.h"

@interface UserMasterCell ()<MyPickerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *text1;

@property (strong, nonatomic) IBOutlet UIButton    *pickButton;
@property (strong, nonatomic) IBOutlet UITextField *text2;
@property (nonatomic, strong) NITPicker            *picker;

@end


@implementation UserMasterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDatasDic:(NSDictionary *)datasDic {
    
    _datasDic=datasDic;
    
    if (self.editOp) {
        [self statusEdit:YES withColor:[UIColor whiteColor]];
        
    } else {
        [self statusEdit:NO withColor:NITColor(235, 235, 241)];
    }
    
    self.text1.text = datasDic[@"staffid"];
    [self.pickButton setTitle:datasDic[@"usertypename"] forState:UIControlStateNormal];
    self.text2.text = datasDic[@"nickname"];
    
}

- (void)statusEdit:(BOOL)noOp withColor:(UIColor *)color {
    NSString *master = [NITUserDefaults objectForKey:@"MASTER_UERTTYPE"];
    if (!master.length) return;
    
    if ([master isEqualToString:@"3"]) {
        
    } else if ([master isEqualToString:@"2"]) {
        
        
    } else {
        [self.text1 setEnabled:noOp];
        [self.text1 setBackgroundColor:color];
        
        [self.pickButton setEnabled:noOp];
        [self.pickButton setBackgroundColor:color];
        
        [self.text2 setEnabled:noOp];
        [self.text2 setBackgroundColor:color];
        
    }
}


- (IBAction)showPick:(UIButton *)sender {
    
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:nil cellNumber:self.cellindex];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
    
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField setBackgroundColor:NITColor(253, 164, 181)];
    
    return YES;
}



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
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"STAFFINFO"]];
    [arr replaceObjectAtIndex:self.cellindex withObject:dic];
    [NITUserDefaults setObject:arr forKey:@"STAFFINFO"];
    
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
