
//  MJRefreshFooter.h
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/3/5.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import "MJRefreshComponent.h"

@interface MJRefreshFooter : MJRefreshComponent

+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

- (void)endRefreshingWithNoMoreData;
- (void)noticeNoMoreData MJRefreshDeprecated("使用endRefreshingWithNoMoreData");


- (void)resetNoMoreData;

@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetBottom;

@property (assign, nonatomic, getter=isAutomaticallyHidden) BOOL automaticallyHidden;
@end
