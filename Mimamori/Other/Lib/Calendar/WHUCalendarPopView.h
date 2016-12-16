//
//  WHUCalendarPopView.h
//  TEST_Calendar
//
//  Created by SuperNova(QQ:422596694) on 15/11/7.
//  Copyright (c) 2015年 SuperNova(QQ:422596694). All rights reserved.

#import <UIKit/UIKit.h>

@interface WHUCalendarPopView : UIView

@property(nonatomic,strong) void(^onDateSelectBlk)(NSDate*);

- (instancetype)initWithFrame:(CGRect)frame;

-(void)dismiss;

-(void)show;


@end
