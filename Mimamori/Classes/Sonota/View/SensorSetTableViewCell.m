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

@property (nonatomic, strong) NSString        *mainname;

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
- (IBAction)mainNodeidSelect:(UIButton *)sender {
    
    self.sensorname.textColor = NITColor(252, 58, 92);
    NSMutableArray *allarr = [NSMutableArray new];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"sensorallnodes"]];
    
    for (NSDictionary *dic in arr) {
        NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [nodesdic setValue:self.nodeid forKey:@"mainnodeid"];
        [allarr addObject:nodesdic];
    }
    [NITUserDefaults setObject:allarr forKey:@"sensorallnodes"];
//    [self updateMainnodenameInfo:self.nodeid andNodename:nil withType:6];
    if (self.segmentbar.selectedSegmentIndex == 0) _mainname = [NSString stringWithFormat:@"%@ (%@)",self.roomname.text,@"外"];
    if (self.segmentbar.selectedSegmentIndex == 1) _mainname = [NSString stringWithFormat:@"%@ (%@)",self.roomname.text,@"内"];
    [NITUserDefaults setObject:@{@"mainnodeid":self.nodeid,@"mainnodename":_mainname} forKey:@"mainondedatakey"];
    
    
    if ([self.delegate respondsToSelector:@selector(NowRefreshScreen)]) {
        [self.delegate NowRefreshScreen];
    }
    
}


- (IBAction)selectPlaceNumber:(UISegmentedControl *)sender {
//    NSString *Path = [NITFilePath stringByAppendingFormat:@"/%@.plist",@"sensorplacelist"];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"sensorallnodes"]];
    NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:self.cellnumber]];
    NSString *value = [NSString stringWithFormat:@"%ld",sender.selectedSegmentIndex + 1];
    [nodesdic setValue:value forKey:@"place"];
    [arr replaceObjectAtIndex:self.cellnumber withObject:nodesdic];
    [NITUserDefaults setObject:arr forKey:@"sensorallnodes"];
    [self updateMainnodenameInfoaNodename:nil withType:sender.selectedSegmentIndex];
}


- (void)updateMainnodenameInfoaNodename:(NSString *)mainnodename withType:(NSInteger)outnum {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NITUserDefaults objectForKey:@"mainondedatakey"]];
    NSString *mainid = dic[@"mainnodeid"];
    if (mainid.length) {
        if (mainnodename.length) {
            if (self.segmentbar.selectedSegmentIndex == 0) _mainname = [NSString stringWithFormat:@"%@ (%@)",mainnodename,@"外"];
            if (self.segmentbar.selectedSegmentIndex == 1) _mainname = [NSString stringWithFormat:@"%@ (%@)",mainnodename,@"内"];
            
        } else {
            if (outnum == 0) _mainname = [NSString stringWithFormat:@"%@ (%@)",self.roomname.text,@"外"];
            if (outnum == 1) _mainname = [NSString stringWithFormat:@"%@ (%@)",self.roomname.text,@"内"];
        }
        dic[@"mainnodename"] = _mainname;
        [NITUserDefaults setObject:dic forKey:@"mainondedatakey"];
    }
    
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.sensorname.layer.cornerRadius = 5;
    self.sensorname.layer.borderWidth = 0.5;
    self.sensorname.layer.borderColor = NITColor(200, 200, 200).CGColor;
//    NITColor(115 , 180, 225);
    self.roomname.layer.cornerRadius = 5;
    self.roomname.layer.borderWidth = 0.5;
    self.roomname.layer.borderColor = NITColor(200, 200, 200).CGColor;
    
//    self.segmentbar.tintColor = NITColor(123, 182, 254);
    
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
    [self updateMainnodenameInfoaNodename:textField.text withType:2];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NITUserDefaults objectForKey:@"sensorallnodes"]];
    NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:self.cellnumber]];
    [nodesdic setValue:textField.text forKey:@"displayname"];
    [arr replaceObjectAtIndex:self.cellnumber withObject:nodesdic];
    [NITUserDefaults setObject:arr forKey:@"sensorallnodes"];
}

@end
