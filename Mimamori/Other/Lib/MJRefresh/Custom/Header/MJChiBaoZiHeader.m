//
//  MJChiBaoZiHeader.m
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/6/12.
//  Copyright © 2015年 NISSAY IT. All rights reserved.
//

#import "MJChiBaoZiHeader.h"

@implementation MJChiBaoZiHeader
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=14; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%lu", (unsigned long)i]];
        [idleImages addObject:image];
    }
     [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%lu-1", (unsigned long)i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}
@end
