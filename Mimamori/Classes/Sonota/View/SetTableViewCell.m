//
//  SetTableViewCell.m
//  Mimamori
//
//  Created by totyu2 on 2016/12/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SetTableViewCell.h"

@implementation SetTableViewCell


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
