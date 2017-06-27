//
//  DetailCCell.m
//  Mimamori2
//
//  Created by NISSAY IT on 2017/1/12.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import "DetailCCell.h"

@implementation DetailCCell



/**
 角裁断
 */
-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgview.layer.borderWidth = 2.5;
    self.bgview.layer.cornerRadius = 6;
    self.bgview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.devicename.layer.borderWidth = 1;
    self.devicename.layer.cornerRadius = 6;
    self.devicename.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.timeValue.layer.borderWidth = 1;
    self.timeValue.layer.cornerRadius = 6;
    self.timeValue.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.valueRp.layer.borderWidth = 1;
    self.valueRp.layer.cornerRadius = 6;
    self.valueRp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}


/**
 登録cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    DetailCCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DetailCCell" owner:self options:nil].firstObject;
    }
    return cell;
}





@end
