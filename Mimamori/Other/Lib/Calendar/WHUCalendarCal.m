//
//  WHUCalendarCal.m
//  TEST_Calendar
//
//  Created by NISSAY IT on 15/11/5.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import "WHUCalendarCal.h"
#import "WHUCalendarItem.h"
#import <UIKit/UIKit.h>
#define WHUCALENDAR_SECOND_PER_DAY (24 * 60 * 60)
@interface WHUCalendarCal()
{
    dispatch_queue_t _workQueue;
}
@property(nonatomic,strong) NSCalendar* curCalendar;
@property(nonatomic,strong) NSString* curDateStr;
@property(nonatomic,strong) NSDictionary* preCalMap;
@property(nonatomic,strong) NSDictionary* nextCalMap;
@property(nonatomic,strong) NSDictionary* currentCalMap;
@end


@implementation WHUCalendarCal

-(id)init{
    self=[super init];
    if(self){
        _workQueue=dispatch_queue_create("WHUCalendarCal_Work_Queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

-(NSCalendar*)curCalendar{
    if(_curCalendar==nil){
        _curCalendar=[NSCalendar currentCalendar];
    }
    return _curCalendar;
}

-(NSString*)currentDateStr{
    NSDate* curDate=[NSDate date];
    NSDateComponents* firstDayOfMonth=[self componentOfDate:curDate];
    if(_curDateStr==nil){
       self.curDateStr =[NSString stringWithFormat:@"%li-%li-%li",(long)firstDayOfMonth.year,(long)firstDayOfMonth.month,(long)firstDayOfMonth.day];
    }
    return _curDateStr;
}

-(NSDictionary*)loadDataWith:(NSString*)dateStr{
    self.currentCalMap=[self calendarMapWith:[self dateFromMonthString:dateStr]];
    dispatch_async(_workQueue, ^{
        if(_preCalMap==nil){
            self.preCalMap=[self getPreCalendarMap:dateStr];
        }
        if(_nextCalMap==nil){
            self.nextCalMap=[self getNextCalendarMap:dateStr];
        }
    });
    return _currentCalMap;
}

-(void)getCalendarMapWith:(NSString*)dateStr completion:(void(^)(NSDictionary* dic))completeBlk{
    
    dispatch_async(_workQueue, ^{
        
        NSString* nextMonthStr=[self nextMonthOfMonthString:dateStr];
        
        NSString* preMonthStr=[self preMonthOfMonthString:dateStr];
        
        if(_preCalMap!=nil&&[_preCalMap[@"monthStr"] isEqualToString:dateStr]){
            
            NSDictionary* tempCur=_currentCalMap;
            
            self.currentCalMap=_preCalMap;
            
            [self dealDateOnMainQueue:completeBlk];
            
            if(tempCur!=nil&&[tempCur[@"monthStr"] isEqualToString:nextMonthStr]){
                
                self.nextCalMap=tempCur;
                
            }
            else{
                self.nextCalMap=nil;
            }
            self.preCalMap=nil;
        }
        else if(_nextCalMap!=nil&&[_nextCalMap[@"monthStr"] isEqualToString:dateStr]){
            NSDictionary* tempCur=_currentCalMap;
            self.currentCalMap=_nextCalMap;
            [self dealDateOnMainQueue:completeBlk];
            if(tempCur!=nil&&[tempCur[@"monthStr"] isEqualToString:preMonthStr]){
                self.preCalMap=tempCur;
            }
            else{
                self.preCalMap=nil;
            }
            self.nextCalMap=nil;
        }
        else{
            if([_currentCalMap[@"monthStr"] isEqualToString:dateStr]){
                [self dealDateOnMainQueue:completeBlk];
            }
            else{
                self.currentCalMap=[self calendarMapWith:[self dateFromMonthString:dateStr]];
                [self dealDateOnMainQueue:completeBlk];
            }
            self.nextCalMap=nil;
            self.preCalMap=nil;
        }
        
        if(_preCalMap==nil){
            self.preCalMap=[self getPreCalendarMap:dateStr];
        }
        
        if(_nextCalMap==nil){
            self.nextCalMap=[self getNextCalendarMap:dateStr];
        }
        
    });
    
}


-(void)dealDateOnMainQueue:(void(^)(NSDictionary*))completeBlk{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(completeBlk!=nil){
            completeBlk(_currentCalMap);
        }
    });
}


-(NSDictionary*)calendarMapWith:(NSDate*)date{
    NSMutableDictionary* mdic=[NSMutableDictionary dictionary];
    NSMutableArray* dateArr=[NSMutableArray array];
    NSCalendar *cal = self.curCalendar;
    NSDate* curDate=date;
    NSRange days = [cal rangeOfUnit:NSCalendarUnitDay
                             inUnit:NSCalendarUnitMonth
                            forDate:curDate];
    NSDateComponents* firstDayOfMonth=[self componentOfDate:curDate];
    
    firstDayOfMonth.day=1;
    
    NSDate* fdate=[cal dateFromComponents:firstDayOfMonth];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd";
    
    firstDayOfMonth=[self componentOfDate:fdate];
    
    if(firstDayOfMonth.weekday!=2){
        
        NSInteger weekGap=firstDayOfMonth.weekday-2;
        
        if(weekGap<0) weekGap+=7;
        
        NSDate* firstDate=[fdate dateByAddingTimeInterval:-WHUCALENDAR_SECOND_PER_DAY*weekGap];
        
        NSDateComponents* firstComponent=[self componentOfDate:firstDate];
        for(int i=0;i<weekGap;i++){
            WHUCalendarItem* item=[[WHUCalendarItem alloc] init];
            
            item.dateStr=[NSString stringWithFormat:@"%ld-%ld-%ld",firstComponent.year,firstComponent.month,firstComponent.day];
            
            item.day=-(firstComponent.day);
//            [self LunarForSolarYear:item andComponent:firstComponent];
            firstComponent.day++;
            
            [dateArr addObject:item];
        }
    }
    
    
    NSDateComponents* curComponents=[self componentOfDate:curDate];
    [mdic setObject:[NSString stringWithFormat:@"%ld年%ld月",(long)curComponents.year,(long)curComponents.month] forKey:@"monthStr"];
    for(int i=1;i<=days.length;i++){
        WHUCalendarItem* item=[[WHUCalendarItem alloc] init];
        curComponents.day=i;
        item.dateStr=[NSString stringWithFormat:@"%ld-%ld-%ld",(long)(curComponents.year),(long)curComponents.month,(long)i];
        item.day=i;
//        [self LunarForSolarYear:item andComponent:curComponents];
        [dateArr addObject:item];
    }
    
    NSDateComponents* lastDayOfMonth=[self componentOfDate:curDate];
    lastDayOfMonth.day=days.length;
    NSDate* ldate=[cal dateFromComponents:lastDayOfMonth];
    lastDayOfMonth=[self componentOfDate:ldate];
    if(lastDayOfMonth.weekday!=1){
        NSInteger weekGap=8-lastDayOfMonth.weekday;
        NSDate* lastDate=[ldate dateByAddingTimeInterval:WHUCALENDAR_SECOND_PER_DAY*weekGap];
        NSDateComponents* lastComponent=[self componentOfDate:lastDate];
        for(int i=1;i<=weekGap;i++){
            WHUCalendarItem* item=[[WHUCalendarItem alloc] init];
            item.dateStr=[NSString stringWithFormat:@"%ld-%ld-%ld",(long)lastComponent.year,(long)lastComponent.month,(long)i];
            item.day=-i;
            lastComponent.day=i;
//            [self LunarForSolarYear:item andComponent:lastComponent];
            [dateArr addObject:item];
        }
    }
    [mdic setObject:[dateArr copy] forKey:@"dataArr"];
    return [mdic copy];
}


-(NSDictionary*)getCalendarMapWith:(NSString*)dateStr{
    NSDate* date=[self dateFromMonthString:dateStr];
    return [self calendarMapWith:date];
}


-(NSDate*)dateFromString:(NSString*)dateString{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate* date=[format dateFromString:dateString];
    return date;
}

-(void)preMonthCalendar:(NSString*)dateStr complete:(void(^)(NSDictionary*))completionBlk{
    NSString* preMonthStr=[self preMonthOfMonthString:dateStr];
    [self getCalendarMapWith:preMonthStr completion:completionBlk];
}

-(void)nextMonthCalendar:(NSString*)dateStr complete:(void(^)(NSDictionary*))completionBlk{
    NSString* preMonthStr=[self nextMonthOfMonthString:dateStr];
    [self getCalendarMapWith:preMonthStr completion:completionBlk];
}

-(NSDictionary*)getPreCalendarMap:(NSString*)dateStr{
    NSDate* date=[self dateFromMonthString:dateStr];
    NSDateComponents* com=[self componentOfDate:date];
    com.month-=1;
    if(com.month<=0){
        com.month+=12;
        com.year-=1;
    }
    date=[self.curCalendar dateFromComponents:com];
    return [self calendarMapWith:date];
}

-(NSDictionary*)getNextCalendarMap:(NSString*)dateStr{
    NSDate* date=[self dateFromMonthString:dateStr];
    NSDateComponents* com=[self componentOfDate:date];
    com.month+=1;
    if(com.month>12){
        com.month-=12;
        com.year+=1;
    }
    date=[self.curCalendar dateFromComponents:com];
    return [self calendarMapWith:date];
}

-(NSString*)preMonthOfMonthString:(NSString*)dateStr{
    NSDate* date=[self dateFromMonthString:dateStr];
    NSDateComponents* com=[self componentOfDate:date];
    com.month-=1;
    if(com.month<=0){
        com.month+=12;
        com.year-=1;
    }
    return [NSString stringWithFormat:@"%ld年%ld月",(long)com.year,(long)com.month];
}


-(NSString*)nextMonthOfMonthString:(NSString*)dateStr{
    NSDate* date=[self dateFromMonthString:dateStr];
    NSDateComponents* com=[self componentOfDate:date];
    com.month+=1;
    if(com.month>12){
        com.month-=12;
        com.year+=1;
    }
    return [NSString stringWithFormat:@"%ld年%ld月",(long)com.year,(long)com.month];
}


-(NSDate*)dateFromMonthString:(NSString*)dateStr{
    dateStr=[dateStr stringByAppendingString:@"01"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd"];
    NSDate* date=[format dateFromString:dateStr];
    return date;
}


-(NSString*)stringFromDate:(NSDate*)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年M月"];
    return [format stringFromDate:date];
}

-(NSDateComponents*)componentOfDate:(NSDate*)date{
    NSCalendar *cal = self.curCalendar;
    NSDateComponents* com=[cal components: NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
//    NSDateComponents *dateComponents = [cal components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:[NSDate date]];
    
    com.hour=0;
    com.minute=0;
    com.second=0;
    return com;
}
@end
