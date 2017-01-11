//
//  DFChildTableViewCell.m
//  Mimamori
//
//  Created by totyu3 on 16/8/5.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#define plistPath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ScenarioItems.plist"]

#import "DFChildTableViewCell.h"
#import "Device.h"
#import "NITPicker.h"

@interface DFChildTableViewCell ()
/**
 *  （温度，湿度，明るさ）   名字
 */
@property (weak, nonatomic) IBOutlet UILabel *dfchildname;
/**
 *  （温度，湿度，明るさ）   单位
 */
@property (weak, nonatomic) IBOutlet UILabel *dfchildunit;
/**
 *  （温度，湿度，明るさ）   时间
 */
@property (weak, nonatomic) IBOutlet UIButton *dfchildtime;
/**
 *  （温度，湿度，明るさ）   值
 */
@property (weak, nonatomic) IBOutlet UIButton *dfchildvalue;
/**
 *  （温度，湿度，明るさ）   以上－以下
 */
@property (weak, nonatomic) IBOutlet UIButton *dfchildtype;

@property (nonatomic, strong) NITPicker       *picker;

- (IBAction)showPickerView:(id)sender;


@end

@implementation DFChildTableViewCell



+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"dfchildcell";
    DFChildTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];

    return cell;
}

-(void)setDevice:(Device *)device{


    _device = device;
    
    [self setupData];

    [self setupButton];

}

-(void)setupData{
    self.dfchildname.text = self.device.devicename;
    self.dfchildunit.text = self.device.valueunit;
    if ([self.device.deviceValue.time intValue]>0) {
        [self.dfchildtime setTitle:[NSString stringWithFormat:@"%@",self.device.deviceValue.time] forState:UIControlStateNormal];
    }else{
        [self.dfchildtime setTitle:@"-" forState:UIControlStateNormal];
    }
    
    if ([self.device.deviceValue.value intValue] >0) {
        [self.dfchildvalue setTitle:[NSString stringWithFormat:@"%@",self.device.deviceValue.value] forState:UIControlStateNormal];
    }else{
        
        [self.dfchildvalue setTitle:@"-" forState:UIControlStateNormal];
    }
   
    [self.dfchildtype setTitle:[NSString stringWithFormat:@"%@",self.device.deviceValue.rpoint] forState:UIControlStateNormal];
}

-(void)setupButton{
    if (self.editType == NO) {
        self.dfchildtime.userInteractionEnabled = YES;
        self.dfchildvalue.userInteractionEnabled = YES;
        self.dfchildtype.userInteractionEnabled = YES;
        
        // 设置背景色
        self.dfchildtime.backgroundColor = NITColor(245, 245, 245);
        self.dfchildvalue.backgroundColor = NITColor(245, 245, 245);
        self.dfchildtype.backgroundColor = NITColor(245, 245, 245);
    }else{
        self.dfchildtime.userInteractionEnabled = NO;
        self.dfchildvalue.userInteractionEnabled = NO;
        self.dfchildtype.userInteractionEnabled = NO;
        
        self.dfchildtime.backgroundColor = [UIColor clearColor];
        self.dfchildvalue.backgroundColor = [UIColor clearColor];
        self.dfchildtype.backgroundColor = [UIColor clearColor];
    }
}


- (IBAction)showPickerView:(id)sender {
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:self.device cellNumber:0];
    [WindowView addSubview:_picker];
}
@end
