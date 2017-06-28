//
//  MJRefreshAutoStateFooter.h
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/6/13.
//  Copyright © 2015年 NISSAY IT. All rights reserved.
//

#import "MJRefreshAutoFooter.h"

@interface MJRefreshAutoStateFooter : MJRefreshAutoFooter

@property (weak, nonatomic, readonly) UILabel *stateLabel;


- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;


@property (assign, nonatomic, getter=isRefreshingTitleHidden) BOOL refreshingTitleHidden;
@end
