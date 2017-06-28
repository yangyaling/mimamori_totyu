//
//  MJRefreshNormalHeader.h
//  MJRefreshExample
//
//  Created by NISSAY IT on 15/4/24.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import "MJRefreshStateHeader.h"

@interface MJRefreshNormalHeader : MJRefreshStateHeader
@property (weak, nonatomic, readonly) UIImageView *arrowView;

@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
