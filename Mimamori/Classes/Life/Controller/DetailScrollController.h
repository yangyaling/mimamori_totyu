//
//  DetailScrollController.h
//  Mimamori
//
//  Created by NISSAY IT on 16/9/26.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZworksChartModel;

@interface DetailScrollController : UIViewController

@property (nonatomic, strong) ZworksChartModel                   *chartModel;  //モデル   

@property (nonatomic, copy) NSString                             *userid0;//入居者ID（見守られる人）

@property (nonatomic) NSInteger                                  selectindex; //現在のページ

@property (nonatomic, assign) NSInteger                          SumPage;  //総ページ数

@property (nonatomic, copy) NSString                             *datestring;  //日付

@end
