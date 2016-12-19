//
//  SickPersonTableViewCell.m
//  Mimamori
//
//  Created by totyu3 on 16/6/3.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SickPersonTableViewCell.h"

@implementation SickPersonTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    SickPersonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sickPersonCell"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"sickPersonCell" owner:self options:nil].firstObject;
        
    }
    
    return cell;
}

-(void)setCellModel:(SickPersonModel *)CellModel{
    
    _CellModel = CellModel;
    
    _sickPersonLabel.text = CellModel.dispname;
}

@end
