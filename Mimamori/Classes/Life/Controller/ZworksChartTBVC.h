//
//  ZworksChartTBVC.h
//  見守る側
//
//  Created by totyu3 on 16/11/16.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpdateChartDelegate <NSObject>

- (void)updateCorrentTB:(int)numChart;

@end


@interface ZworksChartTBVC : UITableViewController

@property (nonatomic, assign) id<PopUpdateChartDelegate>updatedelegate;

@property (nonatomic, strong) NSMutableArray   *zarray;  //chart  datas
@property (nonatomic, assign) NSInteger        superrow; //current  page
@property (nonatomic, assign) int              xnum;    //日(0) 週(1) 月(2)

@property (nonatomic, copy) NSString           *userid0; //入居者ID（見守られる人）
@end
