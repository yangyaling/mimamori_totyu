//
//  MJRefreshAutoGifFooter.h
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/4/24.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import "MJRefreshAutoStateFooter.h"

@interface MJRefreshAutoGifFooter : MJRefreshAutoStateFooter
@property (weak, nonatomic, readonly) UIImageView *gifView;

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;
@end
