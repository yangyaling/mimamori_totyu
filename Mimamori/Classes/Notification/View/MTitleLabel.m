//
//  MTitleLabel.m
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/2.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "MTitleLabel.h"

@implementation MTitleLabel


/**
 初期化ラベル
 */
+(instancetype)titleLabel{
    return [[self alloc]init];
}


/**
 ラベル創建  
 */
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFont:[UIFont systemFontOfSize:16]];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setNumberOfLines:0];
    }
    return self;
}

@end
