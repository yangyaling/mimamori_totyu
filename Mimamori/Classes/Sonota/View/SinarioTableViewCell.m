//
//  SinarioTableViewCell.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SinarioTableViewCell.h"
#import "NITPicker.h"

@interface SinarioTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *temperature;

@property (strong, nonatomic) IBOutlet UILabel *humidity;
@property (strong, nonatomic) IBOutlet UILabel *brightness;

@property (nonatomic, strong) NITPicker       *picker;
@property (strong, nonatomic) IBOutlet UILabel *doalabel;
@property (strong, nonatomic) IBOutlet UIButton *doaState;

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
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    
    return [SinarioTableViewCell cellFromNib:nil andCollectionView:tableView];
}

+ (instancetype)cellFromNib:(NSString *)nibName andCollectionView:(UITableView *)tableView
{
    NSString *className = NSStringFromClass([self class]);
    
    NSString *ID = nibName == nil? className : nibName;
    
    UINib *nib = [UINib nibWithNibName:ID bundle:nil];
    
    [tableView registerNib:nib forCellReuseIdentifier:ID];
    
    return [tableView dequeueReusableCellWithIdentifier:ID];
}

- (IBAction)PickShow:(UIButton *)sender {
    _picker = [[NITPicker alloc]initWithFrame:CGRectZero superviews:WindowView selectbutton:sender model:self.device cellNumber:nil];
    [WindowView addSubview:_picker];
}


@end
