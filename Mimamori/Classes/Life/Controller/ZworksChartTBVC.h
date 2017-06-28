//
//  ZworksChartTBVC.h
//  見守る側
//
//  Created by NISSAY IT on 16/11/16.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpdateChartDelegate <NSObject>

- (void)updateCorrentTB:(int)numChart;

@end


@interface ZworksChartTBVC : UITableViewController

@property (nonatomic, assign) id<PopUpdateChartDelegate>updatedelegate;

@property (nonatomic, strong) NSMutableArray   *zarray;  //チャート・データ
@property (nonatomic, assign) NSInteger        superrow; //現在のページ
@property (nonatomic, assign) int              xnum;    //日(0) 週(1) 月(2)

@property (nonatomic, copy) NSString           *userid0; //入居者ID（見守られる人）
@end
