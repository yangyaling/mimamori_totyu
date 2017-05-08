//
//  MachineCell.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
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

- (void)setDatasDic:(NSDictionary *)datasDic {
    
    _datasDic=datasDic;
    
    if (self.editOp) {
        [self statusEdit:YES withColor:[UIColor whiteColor]];
        
    } else {
        [self statusEdit:NO withColor:NITColor(235, 235, 241)];
    }
    self.sensorIdTF.text = datasDic[@"sensorid"];
    self.serialNoTF.text = datasDic[@"serial"];
    [self.custIdBtn setTitle:datasDic[@"custid"] forState:UIControlStateNormal];
    //self.custIdTF.text = datasDic[@"custid"];
    self.custNameTF.text = datasDic[@"custname"];
    
}

- (void)statusEdit:(BOOL)noOp withColor:(UIColor *)color {
    if ([usertype isEqualToString:@"2"]) {
        [self.serialNoTF setEnabled:NO];
        [self.serialNoTF setBackgroundColor:TextFieldNormalColor];
        
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

- (IBAction)showPick:(UIButton *)sender {
    [sender setBackgroundColor:NITColor(253, 164, 181)];
    self.serialNoTF.backgroundColor = [UIColor whiteColor];
    self.sensorIdTF.backgroundColor = [UIColor whiteColor];
    
    self.custNameTF.backgroundColor = NITColor(253, 164, 181);
    self.custNameTF.userInteractionEnabled = NO;
    
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:nil cellNumber:self.cellindex];
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
    
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.custIdBtn.backgroundColor = [UIColor whiteColor];
    self.custNameTF.backgroundColor = [UIColor whiteColor];
    [textField setBackgroundColor:NITColor(253, 164, 181)];
    
    return YES;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{

    [textField setBackgroundColor:[UIColor whiteColor]];

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

- (void)PickerDelegateSelectString:(NSString *)sinario withDic:(NSDictionary *)addcell{
    NITLog(@"%@",sinario);
    NSArray *custlist = [NITUserDefaults objectForKey:@"custidlist"];
    for (NSDictionary *dict in custlist) {
        if ([dict[@"custid"] isEqualToString:sinario]) {
            self.custNameTF.text = dict[@"custname"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"SENSORINFO"]];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[self.cellindex]];
            
            [dic setObject:self.sensorIdTF.text  forKey:@"sensorid"];
            [dic setObject:dict[@"custid"]  forKey:@"custid"];
            [dic setObject:dict[@"custname"] forKey:@"custname"];
            
            [arr replaceObjectAtIndex:self.cellindex withObject:dic];
            [NITUserDefaults setObject:arr forKey:@"SENSORINFO"];
        }
    }
    
    
    
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
