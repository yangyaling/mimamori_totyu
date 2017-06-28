//
//  WHUCalendarView.h
//  TEST_Calendar
//
//  Created by NISSAY IT on 15/11/5.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WHUCalendarView : UIView 


@property(nonatomic,strong,readonly)  NSDate* selectedDate;




@property(nonatomic,strong) void(^onDateSelectBlk)(NSDate*);



@property(nonatomic,strong) NSDate* currentDate;

-(id)initWithFrame:(CGRect)frame withArray:(NSArray *)array;

@end
