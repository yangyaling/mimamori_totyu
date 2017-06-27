//
//  AddTableViewCell.m
//  Mimamori
//
//  Created by NISSAY IT on 2016/12/14.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "AddTableViewCell.h"

@implementation AddTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    AddTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AddTableViewCell" owner:self options:nil].firstObject;
    }
    return cell;
    
}




@end
