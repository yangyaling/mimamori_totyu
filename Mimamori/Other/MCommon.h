//
//  MCommon.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#ifndef MCommon_h
#define MCommon_h

// 判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 传感器数据缓存沙盒路径
#define NITDataPath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Data"]

// 沙盒路径
#define NITFilePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

// RGB颜色
#define NITColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define NITColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1.0]
// 随机色
#define NITRandomColor NITColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 状态栏Activity
#define NITNetwork [UIApplication sharedApplication].networkActivityIndicatorVisible

// 自定义Log
#ifdef DEBUG //调试阶段
#define NITLog(...) NSLog(__VA_ARGS__)
#else
#define NITLog(...)
#endif

// 通知
#define NITNotificationCenter [NSNotificationCenter defaultCenter]

// UserDefaults
#define NITUserDefaults [NSUserDefaults standardUserDefaults]

#define NITScreenW [UIScreen mainScreen].bounds.size.width
#define NITScreenH [UIScreen mainScreen].bounds.size.height



#define WindowView [UIApplication sharedApplication].windows.lastObject



/**
 sonota   URL
 */

#define NITGetCustInfo @"http://mimamori2.azurewebsites.net/zwgetcustlist.php"

#define NITDeleteCustInfo @"http://mimamori2.azurewebsites.net/zwdeletecust.php"

#define NITAddCustInfo @"http://mimamori2.azurewebsites.net/zwaddcust.php"


#define NITGetUserInfo @"http://mimamori2.azurewebsites.net/zwgetcustinfo.php"

#define NITUpdateUserInfo @"http://mimamori2.azurewebsites.net/zwupdatecustinfo.php"


#define NITGetScenarioList @"http://mimamori2.azurewebsites.net/zwgetscenariolist.php"


#define NITDeleteScenario @"http://mimamori2.azurewebsites.net/zwdeletescenarioinfo.php"

#define NITGetGroupInfo @"http://mimamori2.azurewebsites.net/zwgetgroupinfo.php"


/**
 lift   URL
 */
#define NITGetDailyDeviceInfo @"http://mimamori2.azurewebsites.net/zwgetdailydeviceinfo2.php"

#define NITGetWeeklyDeviceInfo @"http://mimamori2.azurewebsites.net/zwgetweeklydeviceinfo.php"

#define NITGetMonthlyDeviceInfo @"http://mimamori2.azurewebsites.net/zwgetmonthlydeviceinfo.php"



/**
 notice   URL
 */
#define NITGetNoticeInfo @"http://mimamori2.azurewebsites.net/zwgetnoticeinfo.php"

#define NITGetNoticeDateList @"http://mimamori2.azurewebsites.net/zwgetnoticedatelist.php"

#define NITUpdateNoticeInfo @"http://mimamori2.azurewebsites.net/zwupdatenoticeinfo.php"


/**
 login   URL
 */

#define NITLogin @"http://mimamori2.azurewebsites.net/zwlogin.php"

#define NITGetZsessionInfo @"http://mimamori2.azurewebsites.net/zwgetzsessioninfo.php"









#endif /* MCommon_h */
