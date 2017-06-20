//
//  DetailChartViewController.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/9/26.
//  Copyright © 2016年 totyu3. All rights reserved.
//  生活ーグラフ画面（温度・湿度・明るさ）

#import <UIKit/UIKit.h>

@interface DetailChartViewController : UITableViewController


/**
 日付
 */
@property (nonatomic, copy) NSString                      *dateString;


/**
 ノードID
 */
@property (nonatomic, copy) NSString                      *nodeId;

/**
 入居者ID（見守られる人）
 */
@property (nonatomic, copy) NSString                      *userid0;


/**
 datas
 */
@property (nonatomic, strong) NSArray                     *subdeviceinfo;


/**
 current page
 */
@property (nonatomic, assign) NSInteger                    index;

@end
