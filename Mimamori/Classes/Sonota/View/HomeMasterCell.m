//
//  HomeMasterCell.m
//  Mimamori2
//
//  Created by totyu2 on 2017/5/2.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "HomeMasterCell.h"
#import "NITPicker.h"

@interface HomeMasterCell ()<MyPickerDelegate>

@property (nonatomic, strong) NITPicker            *picker;
@property (strong, nonatomic) IBOutlet UITextField *custID;
@property (strong, nonatomic) IBOutlet UITextField *custName;
@property (strong, nonatomic) IBOutlet UIButton *floorbtn;

@property (strong, nonatomic) IBOutlet UIButton *roombtn;


@end


@implementation HomeMasterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/**
 配列コピー
 */
- (void)setDatasDic:(NSDictionary *)datasDic {
    
    _datasDic=datasDic;
    
    //権限状態
    if (self.editOp) {
        
        [self.custName setEnabled:YES];
        [self.custName setBackgroundColor:[UIColor whiteColor]];
        
        [self.roombtn setEnabled:YES];
        [self.roombtn setBackgroundColor:[UIColor whiteColor]];
        
        [self.floorbtn setEnabled:YES];
        [self.floorbtn setBackgroundColor:[UIColor whiteColor]];
        
        
    } else {
        
        [self.custName setEnabled:NO];
        [self.custName setBackgroundColor:TextFieldNormalColor];
        
        [self.roombtn setEnabled:NO];
        [self.roombtn setBackgroundColor:TextFieldNormalColor];
        
        [self.floorbtn setEnabled:NO];
        [self.floorbtn setBackgroundColor:TextFieldNormalColor];
        
    }

    [self.custID setEnabled:NO];
    [self.custID setBackgroundColor:TextFieldNormalColor];
    
    self.custID.text = datasDic[@"custid"];
    self.custName.text = datasDic[@"custname"];
    NSString *floorstr = [NSString stringWithFormat:@"%@",datasDic[@"floorno"]];
    NSString *roomstr = [NSString stringWithFormat:@"%@",datasDic[@"roomcd"]];
    [self.floorbtn setTitle:floorstr forState:UIControlStateNormal];
    [self.roombtn setTitle:roomstr forState:UIControlStateNormal];
    
}


/**
 オプションフレーム
 */
- (IBAction)showPick:(UIButton *)sender {
    NSArray *arr = [NITUserDefaults objectForKey:@"FLOORLISTKEY"];
    
    NSString *floorno = self.floorbtn.titleLabel.text;
    
    if (floorno.length) {
        for (NSDictionary *dic  in arr) {
            if ([dic[@"floorno"] isEqualToString:floorno]) {
                
                NSArray *array = [dic[@"roomlist"] copy];
                
                [NITUserDefaults setObject:array forKey:@"ROOMLISTKEY"];
                
                break;
                
            }
            
        }
        
    } else {
        
        return;
    }
    
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:nil cellNumber:self.cellindex];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
    
}

/**
 //デリゲートの転送
 */
- (void)PickerDelegateSelectString:(NSString *)sinario withDic:(NSDictionary *)addcell {
    NSArray *tmparr = [NITUserDefaults objectForKey:@"FLOORLISTKEY"];
    NSString *roomcd = nil;
    
    //同じことを取り除く
    for (NSDictionary *dic  in tmparr) {
        if ([dic[@"floorno"] isEqualToString:sinario]) {
            
            roomcd = [[dic[@"roomlist"] firstObject] objectForKey:@"roomcd"];
            
            [self.roombtn setTitle:roomcd forState:UIControlStateNormal];
            
            break;
        }
    }
    
    [self.floorbtn setTitle:sinario forState:UIControlStateNormal];
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"HOMECUSTINFO"]];
    //
    //    NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:self.cellindex]];
    
    NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:_datasDic];
    
    [nodesdic setValue:roomcd forKey:@"roomcd"];
    
    [arr replaceObjectAtIndex:self.cellindex withObject:nodesdic];  //この条転送のテキスト欄に入れ替わっ
    
    [NITUserDefaults setObject:arr forKey:@"HOMECUSTINFO"];
    
    
    
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
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"HOMECUSTINFO"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:array[self.cellindex]];
    if (textField.tag == 1) {
        [dic setObject:textField.text forKey:@"custid"];
    } else {
        [dic setObject:textField.text forKey:@"custname"];
    }
    [array replaceObjectAtIndex:self.cellindex withObject:dic];
    [NITUserDefaults setObject:array forKey:@"HOMECUSTINFO"];
    
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
