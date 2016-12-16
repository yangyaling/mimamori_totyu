//
//  PatientDetailsTableViewCell.h
//  Mimamori
//
//  Created by totyu3 on 16/6/3.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientDetailsTableViewCell : UITableViewCell
/**
 *  scenario名字
 */
@property (weak, nonatomic) IBOutlet UILabel *scenarioLabel;
/**
 *  cell初始化
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
