//
//  AddTableViewCell.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "AddTableViewCell.h"

@implementation AddTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    //    SensorSetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"setsensorcell"];
    //    if (!cell) {
    //        cell = [[NSBundle mainBundle] loadNibNamed:@"setsensorcell" owner:self options:nil].firstObject;
    //    }
    //    return cell;
    
    
    return [AddTableViewCell cellFromNib:nil andCollectionView:tableView];
}

+ (instancetype)cellFromNib:(NSString *)nibName andCollectionView:(UITableView *)tableView
{
    NSString *className = NSStringFromClass([self class]);
    
    NSString *ID = nibName == nil? className : nibName;
    
    UINib *nib = [UINib nibWithNibName:ID bundle:nil];
    
    [tableView registerNib:nib forCellReuseIdentifier:ID];
    
    return [tableView dequeueReusableCellWithIdentifier:ID];
}

@end
