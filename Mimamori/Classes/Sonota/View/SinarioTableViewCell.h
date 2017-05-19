//
//  SinarioTableViewCell.h
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinarioTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *sinarioButton;
@property (strong, nonatomic) IBOutlet UIButton *temperaturetime;
@property (strong, nonatomic) IBOutlet UIButton *temperatureTD;
@property (strong, nonatomic) IBOutlet UIButton *humiditytime;
@property (strong, nonatomic) IBOutlet UIButton *humidityTD;
@property (strong, nonatomic) IBOutlet UIButton *brightnesstime;
@property (strong, nonatomic) IBOutlet UIButton *brightnessTD;

@property (strong, nonatomic) IBOutlet UIButton *doaState;
//
//@property (strong, nonatomic) IBOutlet UIButton *dayState;
//
//@property (strong, nonatomic) IBOutlet UIButton *timeSlot;
//
//
//@property (strong, nonatomic) IBOutlet UILabel *timeT;

@property (strong, nonatomic) IBOutlet UILabel *temperature;

@property (strong, nonatomic) IBOutlet UILabel *humidity;
@property (strong, nonatomic) IBOutlet UILabel *brightness;

@property (strong, nonatomic) IBOutlet UIButton *doatime;

@property (strong, nonatomic) IBOutlet UILabel *doalabel;


@property (nonatomic, assign) NSInteger     cellindex;

@property (nonatomic, copy) NSArray     *cellarr;

//+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
