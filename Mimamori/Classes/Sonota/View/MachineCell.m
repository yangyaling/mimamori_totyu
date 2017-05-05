//
//  MachineCell.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "MachineCell.h"
#import "NITPicker.h"

@interface MachineCell ()
@property (weak, nonatomic) IBOutlet UITextField *serialNoTF;
@property (weak, nonatomic) IBOutlet UITextField *sensorIdTF;
@property (weak, nonatomic) IBOutlet UITextField *custIdTF;
@property (weak, nonatomic) IBOutlet UITextField *custNameTF;

@end

@implementation MachineCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDatasDic:(NSDictionary *)datasDic {
    
    _datasDic=datasDic;
    
    if (self.editOp) {
        [self statusEdit:YES withColor:[UIColor whiteColor]];
        
    } else {
        [self statusEdit:NO withColor:NITColor(235, 235, 241)];
    }
    self.sensorIdTF.text = datasDic[@"sensorid"];
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


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField setBackgroundColor:NITColor(253, 164, 181)];
    if (textField.tag == 4) {
#warning todo
        // 获取对应id的ユーザネーム
        
    }
    
    return YES;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{

    [textField setBackgroundColor:[UIColor whiteColor]];
    NSLog(@"%@",textField.text);
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"SENSORINFO"]];
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
    [NITUserDefaults setObject:arr forKey:@"SENSORINFO"];
    
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
