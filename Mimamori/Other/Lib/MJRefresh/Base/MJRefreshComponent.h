
//  MJRefreshComponent.h
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/3/4.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.


#import <UIKit/UIKit.h>
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"
#import "UIScrollView+MJRefresh.h"


typedef NS_ENUM(NSInteger, MJRefreshState) {

    MJRefreshStateIdle = 1,

    MJRefreshStatePulling,

    MJRefreshStateRefreshing,

    MJRefreshStateWillRefresh,
 
    MJRefreshStateNoMoreData
};


typedef void (^MJRefreshComponentRefreshingBlock)();

@interface MJRefreshComponent : UIView
{
    
    UIEdgeInsets _scrollViewOriginalInset;

    __weak UIScrollView *_scrollView;
}
#pragma mark -
@property (copy, nonatomic) MJRefreshComponentRefreshingBlock refreshingBlock;

- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;

@property (weak, nonatomic) id refreshingTarget;

@property (assign, nonatomic) SEL refreshingAction;

- (void)executeRefreshingCallback;

#pragma mark -
- (void)beginRefreshing;

- (void)endRefreshing;

- (BOOL)isRefreshing;

@property (assign, nonatomic) MJRefreshState state;

#pragma mark -
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;

@property (weak, nonatomic, readonly) UIScrollView *scrollView;

#pragma mark

- (void)prepare NS_REQUIRES_SUPER;

- (void)placeSubviews NS_REQUIRES_SUPER;

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

- (void)scrollViewPanStateDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;


#pragma mark -
@property (assign, nonatomic) CGFloat pullingPercent;

@property (assign, nonatomic, getter=isAutoChangeAlpha) BOOL autoChangeAlpha MJRefreshDeprecated("请使用automaticallyChangeAlpha属性");

@property (assign, nonatomic, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;
@end

@interface UILabel(MJRefresh)
+ (instancetype)label;
@end
