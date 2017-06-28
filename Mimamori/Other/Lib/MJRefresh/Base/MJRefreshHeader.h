
//  MJRefreshHeader.h
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/3/4.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.


#import "MJRefreshComponent.h"

@interface MJRefreshHeader : MJRefreshComponent

+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@property (copy, nonatomic) NSString *lastUpdatedTimeKey;

@property (strong, nonatomic, readonly) NSDate *lastUpdatedTime;


@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;
@end
