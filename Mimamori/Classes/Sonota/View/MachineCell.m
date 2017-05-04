//
//  MachineCell.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "MachineCell.h"

@interface MachineCell ()
@property (weak, nonatomic) IBOutlet UITextField *serialNoTF;
@property (weak, nonatomic) IBOutlet UITextField *sensorIdTF;
@property (weak, nonatomic) IBOutlet UITextField *custIdTF;
@property (weak, nonatomic) IBOutlet UITextField *custNameTF;

@end

@implementation MachineCell

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
    self.sensorIdTF.text = datasDic[@"nodename"];
    self.serialNoTF.text = datasDic[@"serial"];
    self.custIdTF.text = datasDic[@"custid"];
    self.custNameTF.text = datasDic[@"custname"];
    
}

- (void)statusEdit:(BOOL)noOp withColor:(UIColor *)color {
    NSString *master = [NITUserDefaults objectForKey:@"MASTER_UERTTYPE"];
    if (!master.length) return;
    
    if ([master isEqualToString:@"3"]) {
        
    } else if ([master isEqualToString:@"2"]) {
        
        
    } else {
//        [self.text1 setEnabled:noOp];
//        [self.text1 setBackgroundColor:color];
//        
//        [self.pickButton setEnabled:noOp];
//        [self.pickButton setBackgroundColor:color];
//        
//        [self.text2 setEnabled:noOp];
//        [self.text2 setBackgroundColor:color];
        
    }
}


//- (IBAction)showPick:(UIButton *)sender {
//    
//    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:nil cellNumber:self.cellindex];
//    
//    _picker.mydelegate = self;
//    
//    [WindowView addSubview:_picker];
//    
//}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField setBackgroundColor:NITColor(253, 164, 181)];
    
    return YES;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setBackgroundColor:[UIColor whiteColor]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_datasDic];
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
