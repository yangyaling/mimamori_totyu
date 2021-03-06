//
//  NSDate+Extension.m
//  
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 NISSAY IT. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString *)needDateStatus:(DateStatus)type
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    
    BOOL hasAMPM = containsA.location != NSNotFound;
    
    if (type == HaveHMSType) {
        [fmt setTimeZone:[NSTimeZone systemTimeZone]];
        [fmt setLocale:[NSLocale systemLocale]];
        fmt.dateFormat =  @"yyyy-MM-dd HH:mm:ss";
        
        return [fmt stringFromDate:self];
        
    }else if (type == HaveHMType){
        
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        return [fmt stringFromDate:self];
        
    }else if (type == NotHaveType) {
        
        fmt.dateFormat = @"yyyy-MM-dd";
        
        return [fmt stringFromDate:self];
        
    } else if(type == HMSType){
        
        fmt.dateFormat =  hasAMPM ? @"aa hh:mm:ss" : @"HH:mm:ss";
        
        return [fmt stringFromDate:self];
    }
    
    else if (type == mojiType){
        
        fmt.dateFormat = @"yyyy年MM月dd日";
        
        return [fmt stringFromDate:self];
        
    }
    
    return nil;
    
}


+ (NSString *)SharedToday
{

    NSDate *nowDate = [NSDate new];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    return [fmt stringFromDate:nowDate];
}


/**
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
}


/**
 */
- (BOOL)isYesterday
{
    NSDate *now = [NSDate date];
    
    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 2014-04-30
    NSString *dateStr = [fmt stringFromDate:self];
    // 2014-10-18
    NSString *nowStr = [fmt stringFromDate:now];
    
    // 2014-10-30 00:00:00
    NSDate *date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}


/**
 */
- (BOOL)isToday
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}


//-----------------------------------------------------------------------------
/**
 */
+(NSInteger)nowTimeType:(timeType)timeType time:(NSDate*)thisTime
{
    NSCalendar*calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags =  NSCalendarUnitEra |
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal |
    NSCalendarUnitQuarter |
    NSCalendarUnitWeekOfMonth |
    NSCalendarUnitWeekOfYear |
    NSCalendarUnitYearForWeekOfYear |
    NSCalendarUnitCalendar |
    NSCalendarUnitTimeZone;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:unitFlags fromDate:thisTime];
    
    NSInteger second = [comps second];
    NSInteger minute = [comps minute];
    NSInteger hour24 = [comps hour];
    NSInteger day = [comps day];
    NSInteger week = [comps weekday];
    NSInteger month = [comps month];
    NSInteger year = [comps year];
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"K"];
    NSInteger hour12 = [[format stringFromDate:thisTime]intValue]-1;
    NSDateFormatter *formatTwo = [[NSDateFormatter alloc] init];
    [formatTwo setDateFormat:@"aa"];
    NSInteger ampm = [[format stringFromDate:thisTime] isEqualToString:@"AM"]?0:1;
    
    switch (timeType) {
        case 1:
            return second;
            break;
            
        case 2:
            return minute;
            break;
            
        case 3:
            return hour12;
            break;
            
        case 4:
            return hour24;
            break;
            
        case 5:
            return day;
            break;
            
        case 6:
            return week;
            break;
            
        case 7:
            return month;
            break;
            
        case 8:
            return year;
            break;
            
        case 9:
            return ampm;
            break;
            
        default:
            return second;
            break;
    }
}
/**
 */
+ (NSString *)otherDay:(NSDate *)thisTime symbols:(timeType)symbols dayNum:(int)dayNum
{
    
    NSDate *LGFdate;
    
    if (symbols == LGFPlus) {
        
        LGFdate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] + dayNum*24*3600)];
        
    }else if (symbols == LGFMinus) {
        
        LGFdate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] - dayNum*24*3600)];
        
    }
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString =  [fmt stringFromDate:LGFdate];
    
    
    return dateString;
    
}
/**
 */
+(NSDate*)otherWeek:(NSDate*)thisTime
{
    
    NSDate *LGFWeekDate;

    NSInteger week =  [self nowTimeType:LGFweek time:thisTime];

    if (week == 1) {
        week = 8;
    }
    
    LGFWeekDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] - (week-1)*24*3600)];
    
    return LGFWeekDate;
    
}
/**
 */
+(NSDate*)otherMonth:(NSDate*)thisTime
{
    
    NSDate *LGFMonthDate;
    
    NSInteger monthDay =  [self nowTimeType:LGFday time:thisTime];

    LGFMonthDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] - monthDay*24*3600)];
    
    return LGFMonthDate;
    
}


/**
 */
+(NSDate *)monthBeginningDateWithDate:(NSDate *)date{
    //NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear
                               | NSCalendarUnitMonth
                               | NSCalendarUnitDay
                               | NSCalendarUnitHour
                               | NSCalendarUnitMinute
                               | NSCalendarUnitSecond
                                          fromDate:date];
    comp.day    = 1;
    comp.hour   = 0;
    comp.minute = 0;
    comp.second = 0;
    NSDate *monthBeginningDate =  [calendar dateFromComponents:comp];
    //NSLog(@"monthBeginningDate = %@",monthBeginningDate);
    //NSLog(@"monthBeginningDate = %@",[monthBeginningDate descriptionWithLocale:[NSLocale currentLocale]]);
    return monthBeginningDate;
}

/**
 */
+(NSDate *)monthEndingDateWithDate:(NSDate *)date{
    //NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear
                               | NSCalendarUnitMonth
                               | NSCalendarUnitDay
                               | NSCalendarUnitHour
                               | NSCalendarUnitMinute
                               | NSCalendarUnitSecond
                                          fromDate:date];
    comp.day    = 1;
    comp.hour   = 0;
    comp.minute = 0;
    comp.second = 0;
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    int lastDay =  (int)range.length;
    comp.day = lastDay;
    NSDate *monthEndingDate = [calendar dateFromComponents:comp];
    //NSLog(@"monthEndingDate = %@",monthEndingDate);
    //NSLog(@"monthEndingDate = %@",[monthEndingDate descriptionWithLocale:[NSLocale currentLocale]]);
    
    
    return monthEndingDate;
}

/**
 */
+(int)daysInMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear
                               | NSCalendarUnitMonth
                               | NSCalendarUnitDay
                               | NSCalendarUnitHour
                               | NSCalendarUnitMinute
                               | NSCalendarUnitSecond
                                          fromDate:date];
    comp.day    = 1;
    comp.hour   = 0;
    comp.minute = 0;
    comp.second = 0;
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return (int)range.length;
    
    
}

/**
 */
+(BOOL)isEarlyThanToday:(NSDate *)date{
    NSString *strDate = [date needDateStatus:NotHaveType]; // yyyy-MM-dd
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy/MM/dd"];
    NSDate *getdate = [fmt dateFromString:strDate];
    
    //選択日と今日を比較
    double timesStart = [getdate timeIntervalSince1970]*1000;
    double timesEnd = [[NSDate new] timeIntervalSince1970]*1000;
    if (timesStart > timesEnd) {
        return NO;
    }else{
        return YES;
    }
}

@end
