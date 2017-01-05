//
//  SensorSetTableViewCell.h
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Device;

@interface SensorSetTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel             *sensorname;

@property (strong, nonatomic) IBOutlet UIButton            *roomname;

@property (strong, nonatomic) IBOutlet UISegmentedControl  *segmentbar;

@property (nonatomic, assign) NSInteger                    cellnumber;

@property (nonatomic, strong) Device *device;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
