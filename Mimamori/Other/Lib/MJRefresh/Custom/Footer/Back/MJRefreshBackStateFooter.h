//
//  MJRefreshBackStateFooter.h
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/6/13.
//  Copyright © 2015年 NISSAY IT. All rights reserved.
//

#import "MJRefreshBackFooter.h"

@interface MJRefreshBackStateFooter : MJRefreshBackFooter
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;

/** 获取state状态下的title */
- (NSString *)titleForState:(MJRefreshState)state;
@end
