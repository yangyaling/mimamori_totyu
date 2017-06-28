//
//  MJRefreshBackStateFooter.h
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/6/13.
//  Copyright © 2015年 NISSAY IT. All rights reserved.
//

#import "MJRefreshBackFooter.h"

@interface MJRefreshBackStateFooter : MJRefreshBackFooter

@property (weak, nonatomic, readonly) UILabel *stateLabel;

- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;


- (NSString *)titleForState:(MJRefreshState)state;
@end
