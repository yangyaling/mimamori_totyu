//
//  SinarioTableViewCell.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SinarioTableViewCell.h"
#import "NITPicker.h"
#import "Device.h"
@interface SinarioTableViewCell ()

@property (nonatomic, strong) NITPicker       *picker;

@end


@implementation SinarioTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.sinarioButton.layer.cornerRadius = 6;
    self.temperature.layer.cornerRadius = 6;
    self.humidity.layer.cornerRadius = 6;
    self.brightness.layer.cornerRadius = 6;
    self.temperaturetime.layer.cornerRadius = 6;
    self.temperatureTD.layer.cornerRadius = 6;
    self.humiditytime.layer.cornerRadius = 6;
    self.humidityTD.layer.cornerRadius = 6;
    self.brightnesstime.layer.cornerRadius = 6;
    self.brightnessTD.layer.cornerRadius = 6;
    self.doalabel.layer.cornerRadius = 6;
    self.doaState.layer.cornerRadius = 6;
    self.doatime.layer.cornerRadius = 6;
//    self.dayState.layer.cornerRadius = 6;
//    self.timeSlot.layer.cornerRadius = 6;
    
    
    self.sinarioButton.layer.borderWidth = 0.6;
    self.temperature.layer.borderWidth = 0.6;
    self.humidity.layer.borderWidth = 0.6;
    self.brightness.layer.borderWidth = 0.6;
    self.temperaturetime.layer.borderWidth = 0.6;
    self.temperatureTD.layer.borderWidth = 0.6;
    self.humidityTD.layer.borderWidth = 0.6;
    self.brightnesstime.layer.borderWidth = 0.6;
    self.brightnessTD.layer.borderWidth = 0.6;
    self.humiditytime.layer.borderWidth = 0.6;
    self.doalabel.layer.borderWidth = 0.6;
    self.doaState.layer.borderWidth = 0.6;
    self.doatime.layer.borderWidth = 0.6;
//    self.dayState.layer.borderWidth = 0.6;
//    self.timeSlot.layer.borderWidth = 0.6;
    
    
    self.humiditytime.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.sinarioButton.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.temperature.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.humidity.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.brightness.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.temperaturetime.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.temperatureTD.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.humidityTD.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.brightnesstime.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.brightnessTD.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.doalabel.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.doaState.layer.borderColor = NITColor(211, 211, 211).CGColor;
    self.doatime.layer.borderColor = NITColor(211, 211, 211).CGColor;
//    self.dayState.layer.borderColor = NITColor(211, 211, 211).CGColor;
//    self.timeSlot.layer.borderColor = NITColor(211, 211, 211).CGColor;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    SinarioTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SinarioTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SinarioTableViewCell" owner:self options:nil].firstObject;
//
    }
    return cell;
}

- (IBAction)PickShow:(UIButton *)sender {
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:nil cellNumber:self.cellindex];
    [WindowView addSubview:_picker];
}

-(void)setCellarr:(NSArray *)cellarr {
    
    if (cellarr.count == 0) {
        self.hidden = YES;
        return;
    }
    
    NSDictionary *dicOne = cellarr.firstObject;
    
    NSDictionary *dicTwo = [cellarr objectAtIndex:1];
    
    NSDictionary *dicThree = [cellarr objectAtIndex:2];
    
    NSDictionary *dicFour = cellarr.lastObject;
    
    
    if ([dicOne[@"detailno"] integerValue] == 0 && [dicTwo[@"detailno"] integerValue] == 0 && [dicThree[@"detailno"] integerValue] == 0 && [dicFour[@"detailno"] integerValue] == 0){
        
        self.hidden = YES;
        return;
    }
    
    
    [self.sinarioButton setTitle:dicOne[@"displayname"] forState:UIControlStateNormal];
    
    //门 - 人感
    if ([dicOne[@"nodetype"] integerValue] == 2) {
        
        self.doalabel.text = @"開閉";
        
    } else {
        
        self.doalabel.text = @"人感";
    }
    
    NSString *strT4 = [NSString stringWithFormat:@"%@%@",dicOne[@"time"],dicOne[@"timeunit"]];
    NSString *strV4 = dicOne[@"rpoint"];
    [self.doatime setTitle:strT4 forState:UIControlStateNormal];
    [self.doaState setTitle:strV4 forState:UIControlStateNormal];
    
//    [self.doaState setTitle:dicOne[@"rpoint"] forState:UIControlStateNormal];
    
    //温度
    self.temperature.text = dicTwo[@"devicename"];
    NSString *strT1 = [NSString stringWithFormat:@"%@%@",dicTwo[@"time"],dicTwo[@"timeunit"]];
    NSString *strV1 = [NSString stringWithFormat:@"%@%@%@",dicTwo[@"value"],dicTwo[@"valueunit"],dicTwo[@"rpoint"]];
    [self.temperaturetime setTitle:strT1 forState:UIControlStateNormal];
    [self.temperatureTD setTitle:strV1 forState:UIControlStateNormal];
    
    
    //湿度
    self.humidity.text = dicThree[@"devicename"];
    NSString *strT2 = [NSString stringWithFormat:@"%@%@",dicThree[@"time"],dicThree[@"timeunit"]];
    NSString *strV2 = [NSString stringWithFormat:@"%@%@%@",dicThree[@"value"],dicThree[@"valueunit"],dicThree[@"rpoint"]];
    [self.humiditytime setTitle:strT2 forState:UIControlStateNormal];
    [self.humidityTD setTitle:strV2 forState:UIControlStateNormal];
    //照明
    self.brightness.text = dicFour[@"devicename"];
    NSString *strT3 = [NSString stringWithFormat:@"%@%@",dicFour[@"time"],dicFour[@"timeunit"]];
    NSString *strV3 = [NSString stringWithFormat:@"%@%@%@",dicFour[@"value"],dicFour[@"valueunit"],dicFour[@"rpoint"]];
    [self.brightnesstime setTitle:strT3 forState:UIControlStateNormal];
    [self.brightnessTD setTitle:strV3 forState:UIControlStateNormal];
    
    
}


@end
