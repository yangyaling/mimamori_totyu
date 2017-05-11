//
//  ZworksChartVTBCell.h
//  見守る側
//
//  Created by totyu3 on 16/9/13.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZworksChartModel.h"

@interface ZworksChartVTBCell : UITableViewCell

/**
 *  sensordata模型
 */
@property (nonatomic, strong)  ZworksChartModel *CellModel;

@property (nonatomic, strong) NSArray           *cellarr;

@property (nonatomic) NSInteger                 superrow;

@property (nonatomic) int                       xnum;

@property (nonatomic, copy) NSString                      *datestr;

@property (nonatomic, copy) NSString                      *labelstr;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
