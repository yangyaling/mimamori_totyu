//
//  DetailChartCell.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/9/26.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZworksChartModel;

@interface DetailChartCell : UITableViewCell

@property (nonatomic, strong)  NSDictionary *chartdic;

@property (nonatomic, copy)    NSString         *dateStr;

@property (nonatomic, copy)    NSString         *nodeID;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
