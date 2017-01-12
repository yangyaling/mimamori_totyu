//
//  DetailCCell.m
//  Mimamori2
//
//  Created by totyu2 on 2017/1/12.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "DetailCCell.h"

@implementation DetailCCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    DetailCCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DetailCCell" owner:self options:nil].firstObject;
    }
    return cell;
}





@end
