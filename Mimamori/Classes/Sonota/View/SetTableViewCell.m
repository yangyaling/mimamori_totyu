//
//  SetTableViewCell.m
//  Mimamori
//
//  Created by NISSAY IT on 2016/12/14.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "SetTableViewCell.h"

@implementation SetTableViewCell


/**
 登録セル

 */
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    return [SetTableViewCell cellFromNib:nil andCollectionView:tableView];
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
