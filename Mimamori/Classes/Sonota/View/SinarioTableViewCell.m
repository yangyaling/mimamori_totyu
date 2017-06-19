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
@interface SinarioTableViewCell ()<MyPickerDelegate>

@property (nonatomic, strong) NITPicker       *picker;

@end


@implementation SinarioTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (IBAction)PickShow:(UIButton *)sender {
    BOOL isOn = YES;
    NSString *str = self.doaState.titleLabel.text;
    if ([str isEqualToString:@"使用なし"] || [str isEqualToString:@"反応なし"]) {
        isOn = NO;
    }
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:isOn ? nil : @[@(isOn)] cellNumber:self.cellindex];
    
    _picker.mydelegate = self;
    
    [WindowView addSubview:_picker];
    
}

- (void)PickerDelegateSelectString:(NSString *)sinario withDic:(NSDictionary *)addcell {
    
    [self.doaState setTitle:sinario forState:UIControlStateNormal];
    
    if ([sinario isEqualToString:@"-"]) {
        return;
    }
    
    if ([sinario isEqualToString:@"使用なし"] || [sinario isEqualToString:@"反応なし"]) {
        [self.doatime setTitle:@"-" forState:UIControlStateNormal];
    } else {
        [self.doatime setTitle:@"0H" forState:UIControlStateNormal];
    }
}

-(void)setCellarr:(NSArray *)cellarr {
    
    if (cellarr.count != 4) {
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
