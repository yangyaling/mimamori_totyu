//
//  WHUCalendarYMSelectView.h
//  TEST_Calendar
//
//  Created by NISSAY IT on 15/11/6.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHUCalendarYMSelectView : UIView
@property(nonatomic,strong,readonly) NSString* selectdDateStr;


+ (instancetype)currentYear:(NSInteger)year withMonth:(NSInteger)month;

@end
