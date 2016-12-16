//
//  DetailChartViewController.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/9/26.
//  Copyright © 2016年 totyu3. All rights reserved.
//  生活ーグラフ画面（温度・湿度・明るさ）

#import <UIKit/UIKit.h>

@interface DetailChartViewController : UITableViewController


@property (nonatomic, copy) NSString                      *dateString;

@property (nonatomic, copy) NSString                      *nodeId;

@property (nonatomic, copy) NSString                      *userid0;

@property (nonatomic, strong) NSArray                     *subdeviceinfo;

@end
