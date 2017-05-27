//
//  DetailScrollController.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/9/26.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZworksChartModel;

@interface DetailScrollController : UIViewController

@property (nonatomic, strong) ZworksChartModel                   *chartModel;

@property (nonatomic, copy) NSString                             *userid0;

@property (nonatomic, copy) NSString                             *updatename;

@property (nonatomic) NSInteger                                  selectindex;

@property (nonatomic, assign) NSInteger                          SumPage;

@property (nonatomic, copy) NSString                      *datestring;

@end
