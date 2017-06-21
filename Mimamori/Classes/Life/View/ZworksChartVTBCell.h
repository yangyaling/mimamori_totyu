//
//  ZworksChartVTBCell.h
//  見守る側
//
//  Created by totyu3 on 16/9/13.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZworksChartVTBCell : UITableViewCell


/**
 cell   datas
 */
@property (nonatomic, strong) NSArray           *cellarr;

@property (nonatomic) NSInteger                 superrow;

@property (nonatomic) int                       xnum;

@property (nonatomic, copy) NSString                      *datestr; //日付

@property (nonatomic, copy) NSString                      *labelstr;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
