//
//  WHUCalendarItem.h
//  TEST_Calendar
//
//  Created by NISSAY IT on 15/11/5.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHUCalendarItem : NSObject
@property(nonatomic,strong) NSString* dateStr; //yyyy-MM-dd
@property(nonatomic,assign) NSInteger day;  
@property (nonatomic, strong) NSString *Chinese_calendar;//
@property (nonatomic, strong) NSString *holiday;//
@end
