//
//  MJRefreshStateHeader.h
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/4/24.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import "MJRefreshHeader.h"

@interface MJRefreshStateHeader : MJRefreshHeader
#pragma mark - 
@property (copy, nonatomic) NSString *(^lastUpdatedTimeText)(NSDate *lastUpdatedTime);

@property (weak, nonatomic, readonly) UILabel *lastUpdatedTimeLabel;

#pragma mark -
@property (weak, nonatomic, readonly) UILabel *stateLabel;

- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;
@end
