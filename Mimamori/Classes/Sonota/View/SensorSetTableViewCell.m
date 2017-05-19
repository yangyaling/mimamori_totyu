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

@interface SensorSetTableViewCell ()

@property (nonatomic, strong) NITPicker       *picker;

@property (nonatomic, strong) NSString        *mainname;

@property (nonatomic, strong) NSMutableArray       *allarray;


@end

@implementation SensorSetTableViewCell

//+ (instancetype)cellWithTableView:(UITableView *)tableView {
//    
//    SensorSetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SensorSetTableViewCell"];
//    if (!cell) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"SensorSetTableViewCell" owner:self options:nil].firstObject;
//        cell.roomname.delegate = cell;
//        cell.roomname.spellCheckingType = UITextSpellCheckingTypeNo;
//        cell.roomname.autocorrectionType = UITextAutocorrectionTypeNo;
//    }
//    return cell;
//    
//}
- (IBAction)showPicker:(UIButton *)sender {
    
    NSArray *arr = [NITUserDefaults objectForKey:@"tempdisplaylist"];
    if (arr.count > 0) {
        _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:nil cellNumber:self.cellnumber];
        [WindowView addSubview:_picker];
    } else {
//        [MBProgressHUD showError:@""];
        NITLog(@"displaylist为空");
    }
}

-(void)setSuperEdit:(BOOL)SuperEdit{
    
    if (SuperEdit) {
        
        _roomname.backgroundColor = [UIColor whiteColor];
        
    }else{
        
        _roomname.backgroundColor = TextFieldNormalColor;
    }
    
    _segmentbar.userInteractionEnabled = SuperEdit;
    _roomname.userInteractionEnabled = SuperEdit;
    _pickBtn.userInteractionEnabled = SuperEdit;
}


- (IBAction)mainNodeidSelect:(UIButton *)sender {
    
    self.sensorname.textColor = NITColor(252, 58, 92);
    
    
    NSMutableDictionary *mainnodesdic = [NSMutableDictionary dictionaryWithDictionary:[NITUserDefaults objectForKey:@"mainondedatakey"]];
    
    [mainnodesdic setValue:self.sensorname.text forKey:@"mainnodeid"];
    
    [mainnodesdic setValue:self.pickBtn.titleLabel.text forKey:@"mainnodename"];
    
    [mainnodesdic setValue:self.segmentbar.selectedSegmentIndex == 0 ? @"外" : @"内" forKey:@"mainnodeplace"];
    
    [NITUserDefaults setObject:mainnodesdic forKey:@"mainondedatakey"];
    
    NSMutableArray *allarr = [NSMutableArray new];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"sensorallnodes"]]];
    for (NSDictionary *dic in arr) {
        NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [nodesdic setValue:self.nodeid forKey:@"mainnodeid"];
        [allarr addObject:nodesdic];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allarr];
    [NITUserDefaults setObject:data forKey:@"sensorallnodes"];
    
//    [self updateMainnodenameInfo:self.nodeid andNodename:nil withType:6];
//    if (self.segmentbar.selectedSegmentIndex == 0) _mainname = [NSString stringWithFormat:@"%@ (%@)",self.roomname.text,@"外"];
//    if (self.segmentbar.selectedSegmentIndex == 1) _mainname = [NSString stringWithFormat:@"%@ (%@)",self.roomname.text,@"内"];
//    [NITUserDefaults setObject:@{@"mainnodeid":self.nodeid,@"mainnodename":_mainname} forKey:@"mainondedatakey"];
    
    
    if ([self.delegate respondsToSelector:@selector(NowRefreshScreen)]) {
        [self.delegate NowRefreshScreen];
    }
    
    
}


- (IBAction)selectPlaceNumber:(UISegmentedControl *)sender {
    NSMutableDictionary *mainnodesdic = [NSMutableDictionary dictionaryWithDictionary:[NITUserDefaults objectForKey:@"mainondedatakey"]];
    [mainnodesdic setValue:sender.selectedSegmentIndex == 0 ? @"外" : @"内" forKey:@"mainnodeplace"];
    
    [NITUserDefaults setObject:mainnodesdic forKey:@"mainondedatakey"];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"sensorallnodes"]]];
    NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:self.cellnumber]];
    NSString *value = [NSString stringWithFormat:@"%ld",sender.selectedSegmentIndex + 1];
    
    [nodesdic setValue:value forKey:@"place"];
    
    [nodesdic setValue:sender.selectedSegmentIndex == 0 ? @"外" : @"内" forKey:@"placename"];
    
    [arr replaceObjectAtIndex:self.cellnumber withObject:nodesdic];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    
    [NITUserDefaults setObject:data forKey:@"sensorallnodes"];
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
    
    self.pickBtn.layer.cornerRadius = 5;
    self.pickBtn.layer.borderWidth = 0.5;
    self.pickBtn.layer.borderColor = NITColor(200, 200, 200).CGColor;
    
//    self.segmentbar.tintColor = NITColor(123, 182, 254);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField setBackgroundColor:NITColor(253, 164, 181)];
    
    return YES;
}

//
////输入框编辑完成以后，将视图恢复到原始状态
//
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setBackgroundColor:[UIColor whiteColor]];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NITUserDefaults objectForKey:@"sensorallnodes"]]];
    NSMutableDictionary *nodesdic = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:self.cellnumber]];
    [nodesdic setValue:textField.text forKey:@"memo"];
    [arr replaceObjectAtIndex:self.cellnumber withObject:nodesdic];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [NITUserDefaults setObject:data forKey:@"sensorallnodes"];
}

@end
