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


/**
 chart datas
 */
@property (nonatomic, strong)  NSDictionary *chartdic;


/**
 日付
 */
@property (nonatomic, copy)    NSString         *dateStr;

/**
 ノードID
 */
@property (nonatomic, copy)    NSString         *nodeID;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
