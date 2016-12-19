//
//  PatientDetailsTableViewCell.m
//  Mimamori
//
//  Created by totyu3 on 16/6/3.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "PatientDetailsTableViewCell.h"

@implementation PatientDetailsTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    PatientDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"scenarioCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"scenarioCell" owner:self options:nil].firstObject;
    }
    return cell;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
