//
//  ZworksChartTBVC.h
//  見守る側
//
//  Created by totyu3 on 16/11/16.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZworksChartTBVC : UITableViewController
@property (nonatomic, strong) NSMutableArray *zarray;
@property (nonatomic, assign) NSInteger        superrow;
@property (nonatomic, assign) int              xnum;
//@property (nonatomic, copy) NSString           *currentDate; //当前图标日期
@property (nonatomic, copy) NSString          *userid0;
@end
