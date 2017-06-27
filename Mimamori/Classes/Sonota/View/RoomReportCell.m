//
//  RoomReportCell.m
//  Mimamori2
//
//  Created by NISSAY IT on 2017/5/4.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import "RoomReportCell.h"
//#import "NITPicker.h"
@interface RoomReportCell ()
//<MyPickerDelegate>
//@property (nonatomic, strong) NITPicker            *picker;
@property (strong, nonatomic) IBOutlet UITextField *floor;
@property (strong, nonatomic) IBOutlet UITextField *roomcd;

@end


@implementation RoomReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
/**
 配列コピー
 */
- (void)setDatasDic:(NSDictionary *)datasDic {
    
    _datasDic=datasDic;
    
    if (self.editOp) {
        [self statusEdit:YES withColor:[UIColor whiteColor]];
        
    } else {
        [self statusEdit:NO withColor:NITColor(235, 235, 241)];
    }
    NSString *floorstr = [NSString stringWithFormat:@"%@",datasDic[@"floorno"]];
    NSString *roomstr = [NSString stringWithFormat:@"%@",datasDic[@"roomcd"]];
    
    self.floor.text = floorstr;
    self.roomcd.text = roomstr;
    
}
/**
 コントロールの権限状態
 */
- (void)statusEdit:(BOOL)noOp withColor:(UIColor *)color {
    
    NSString *master = [NITUserDefaults objectForKey:@"MASTER_UERTTYPE"];
    
    if (!master.length) return;
    
    if ([master isEqualToString:@"3"]) {
        
    } else if ([master isEqualToString:@"2"]) {
        
        
    } else {
        [self.floor setEnabled:noOp];
        [self.floor setBackgroundColor:color];
        
        [self.roomcd setEnabled:noOp];
        [self.roomcd setBackgroundColor:color];
        
    }
    
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
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"ROOMMASTERINFOKEY"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:array[self.cellindex]];
    if (textField.tag == 1) {
        [dic setObject:textField.text forKey:@"floorno"];
    } else {
        [dic setObject:textField.text forKey:@"roomcd"];
    }
    [array replaceObjectAtIndex:self.cellindex withObject:dic];
    [NITUserDefaults setObject:array forKey:@"ROOMMASTERINFOKEY"];
    
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
