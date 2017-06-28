//
//  MJRefreshBackGifFooter.h
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/4/24.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import "MJRefreshBackStateFooter.h"

@interface MJRefreshBackGifFooter : MJRefreshBackStateFooter
@property (weak, nonatomic, readonly) UIImageView *gifView;


- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;
@end
