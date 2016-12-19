//
//  MBatteryButton.m
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/2.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "MBatteryButton.h"

@implementation MBatteryButton

+(instancetype)batteryButton{
    return [[self alloc]init];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景颜色
        self.backgroundColor =  [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        // 标题颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 文字字体
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self setImageEdgeInsets:UIEdgeInsetsMake(5, NITScreenW - 35, 5,5)];
        
        self.userInteractionEnabled = NO;
    }
    return self;
}

@end
