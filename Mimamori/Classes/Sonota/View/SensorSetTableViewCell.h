//
//  SensorSetTableViewCell.h
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SensorSetTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel             *sensorname;

@property (strong, nonatomic) IBOutlet UITextField         *roomname;

@property (strong, nonatomic) IBOutlet UISegmentedControl  *segmentbar;

@property (nonatomic, assign) NSInteger                    cellnumber;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
