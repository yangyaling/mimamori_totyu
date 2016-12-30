//
//  SinarioTableViewCell.h
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Device;
@interface SinarioTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *sinarioButton;
@property (strong, nonatomic) IBOutlet UIButton *temperaturetime;
@property (strong, nonatomic) IBOutlet UIButton *temperatureTD;
@property (strong, nonatomic) IBOutlet UIButton *humiditytime;
@property (strong, nonatomic) IBOutlet UIButton *humidityTD;
@property (strong, nonatomic) IBOutlet UIButton *brightnesstime;
@property (strong, nonatomic) IBOutlet UIButton *brightnessTD;
@property (strong, nonatomic) IBOutlet UIButton *nasiButton;

@property (nonatomic, copy) Device *device;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
