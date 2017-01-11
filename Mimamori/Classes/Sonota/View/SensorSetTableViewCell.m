//
//  SensorSetTableViewCell.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SensorSetTableViewCell.h"

#import "NITPicker.h"

#import "Device.h"

@interface SensorSetTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, strong) NITPicker       *picker;


@property (nonatomic, strong) NSMutableArray       *allarray;

@end

@implementation SensorSetTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    SensorSetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SensorSetTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SensorSetTableViewCell" owner:self options:nil].firstObject;
        cell.roomname.delegate = cell;
        cell.roomname.spellCheckingType = UITextSpellCheckingTypeNo;
        cell.roomname.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return cell;
    
}


//- (IBAction)clickPick:(UIButton *)sender {
//    
//    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:self.device cellNumber:self.cellnumber];
//    [WindowView addSubview:_picker];
//    
//}


- (IBAction)selectPlaceNumber:(UISegmentedControl *)sender {
//    NSString *Path = [NITFilePath stringByAppendingFormat:@"/%@.plist",@"sensorplacelist"];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"sensorallnodes"]];
    NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:self.cellnumber]];
    NSString *value = [NSString stringWithFormat:@"%ld",sender.selectedSegmentIndex + 1];
    [nodesdic setValue:value forKey:@"place"];
    [arr replaceObjectAtIndex:self.cellnumber withObject:nodesdic];
    [NITUserDefaults setObject:arr forKey:@"sensorallnodes"];
    
}


- (void)awakeFromNib

{
    
    [super awakeFromNib];
    
    
    self.sensorname.layer.cornerRadius = 5;
    self.sensorname.layer.borderWidth = 0.5;
    self.sensorname.layer.borderColor = NITColor(200, 200, 200).CGColor;
    self.sensorname.backgroundColor = [UIColor whiteColor];
//    NITColor(115 , 180, 225);
    self.roomname.layer.cornerRadius = 5;
    self.roomname.layer.borderWidth = 0.5;
    self.roomname.layer.borderColor = NITColor(200, 200, 200).CGColor;
    
    self.segmentbar.tintColor = NITColor(123, 182, 254);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//
////输入框编辑完成以后，将视图恢复到原始状态
//
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"sensorallnodes"]];
    NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:self.cellnumber]];
    [nodesdic setValue:textField.text forKey:@"displayname"];
    [arr replaceObjectAtIndex:self.cellnumber withObject:nodesdic];
    [NITUserDefaults setObject:arr forKey:@"sensorallnodes"];
}

@end
