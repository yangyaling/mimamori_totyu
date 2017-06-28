//
//  DetailChartCell.h
//  Mimamori
//
//  Created by NISSAY IT on 16/9/26.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZworksChartModel;

@interface DetailChartCell : UITableViewCell


/**
 チャート・データ
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
