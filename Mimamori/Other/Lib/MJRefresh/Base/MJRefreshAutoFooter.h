//
//  MJRefreshAutoFooter.h
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/4/24.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import "MJRefreshFooter.h"

@interface MJRefreshAutoFooter : MJRefreshFooter

@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;


@property (assign, nonatomic) CGFloat appearencePercentTriggerAutoRefresh MJRefreshDeprecated("请使用automaticallyChangeAlpha属性");


@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;
@end
