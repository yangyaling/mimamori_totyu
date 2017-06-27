//
//  MJRefreshBackNormalFooter.h
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/4/24.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import "MJRefreshBackStateFooter.h"

@interface MJRefreshBackNormalFooter : MJRefreshBackStateFooter
@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
