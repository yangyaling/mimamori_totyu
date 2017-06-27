//
//  NSDate+Extension.h
//
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    HaveHMSType,//yyyy-MM-dd HH:mm:ss
    HaveHMType,//yyyy-MM-dd HH:mm
    NotHaveType,//yyyy-MM-dd
    HMSType,//HH:mm:ss
    mojiType //yyyy年MM月dd日
    
}DateStatus;

typedef enum {

    LGFampm = 9,       //
    LGFyear = 8,       //年
    LGFmonth = 7,      //月
    LGFweek = 6,       //周
    LGFday = 5,        //日
    LGFhour24 = 4,     //24
    LGFhour12 = 3,     //12
    LGFminute = 2,     
    LGFsecond = 1,     //
    
    LGFPlus,           // +
    LGFMinus,          // -
    
}timeType;

@interface NSDate (Extension)
/**
 *
 */
- (BOOL)isThisYear;
/**
 *
 */
- (BOOL)isYesterday;
/**
 *
 */
- (BOOL)isToday;


/**
 *
 */
+ (NSString *)SharedToday;

/**
 *
 */
- (NSString *)needDateStatus:(DateStatus)type;
//-----------------------------------------------------------------------------
/**
 *
 */
+(NSInteger)nowTimeType:(timeType)timeType time:(NSDate*)thisTime;
/**
 *
 */
+(NSString *)otherDay:(NSDate*)thisTime symbols:(timeType)symbols dayNum:(int)dayNum;
/**
 *
 */
+(NSDate*)otherWeek:(NSDate*)thisTime;
/**
 *
 */
+(NSDate*)otherMonth:(NSDate*)thisTime;

/**
 *
 */
+(NSDate *)monthBeginningDateWithDate:(NSDate *)date;
/**
 *
 */
+(NSDate *)monthEndingDateWithDate:(NSDate *)date;
/**
 *
 */
+(int)daysInMonth:(NSDate *)date;

/**
 *
 */
+(BOOL)isEarlyThanToday:(NSDate *)date;
@end
