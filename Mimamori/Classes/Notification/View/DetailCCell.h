//
//  DetailCCell.h
//  Mimamori2
//
//  Created by NISSAY IT on 2017/1/12.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *devicename;


@property (strong, nonatomic) IBOutlet UILabel *timeValue;

@property (strong, nonatomic) IBOutlet UILabel *valueRp;

@property (strong, nonatomic) IBOutlet UIView *bgview;




+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
