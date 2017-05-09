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

//Directory存储
#define NITDocumentDirectory NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
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

#define NSNullJudge(str) (str)==[NSNull null] ? @"" : (str)

#define WindowView [UIApplication sharedApplication].windows.lastObject


// ユーザ分類　x;1;2;3
#define USERTYPE [NITUserDefaults objectForKey:@"MASTER_UERTTYPE"];
#define TextFieldNormalColor NITColor(235, 235, 241)
/**
 sonota   URL
 */




#define NITUpdateUserInfo @"http://mimamori2p1.azurewebsites.net/zwupdateuserinfo.php"


#define NITGetUserInfo @"http://mimamori2p1.azurewebsites.net/zwgetuserinfo.php"


#define NITGetCustList @"http://mimamori2p1.azurewebsites.net/zwgetcustlist.php"

#define NITDeleteCustList @"http://mimamori2p1.azurewebsites.net/zwdeletecust.php"

#define NITAddCustList @"http://mimamori2p1.azurewebsites.net/zwaddcust.php"



#define NITGetCustInfo @"http://mimamori2p1.azurewebsites.net/zwgetcustinfo.php"

#define NITUpdateCustInfo @"http://mimamori2p1.azurewebsites.net/zwupdatecustinfo.php"

#define NITUploadpic @"http://mimamori2p1.azurewebsites.net/upload/zwuploadpic.php"


#define NITGetScenarioList @"http://mimamori2p1.azurewebsites.net/zwgetsslist.php"

#define NITUpdateSensorInfo @"http://mimamori2p1.azurewebsites.net/zwupdatenodeplaceinfo.php"


#define NITDeleteScenario @"http://mimamori2p1.azurewebsites.net/zwdeletescenarioinfo.php"

#define NITGetGroupInfo @"http://mimamori2p1.azurewebsites.net/zwgetgroupinfo.php"

#define NITGetScenarioInfo @"http://mimamori2p1.azurewebsites.net/zwgetscenariodtlinfo.php"

#define NITUpdateScenarioInfo @"http://mimamori2p1.azurewebsites.net/zwupdatescenarioinfo.php"



/*Master管理者接口*/
#define NITGetNLInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwgetnlinfo.php"

#define NITUpdateNLInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwupdatenlinfo.php"

#define NITDeleteNLInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwdeletenlinfo.php"

#define NITGetCompanyInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwgetcompanyinfo.php"

#define NITUpdateCompanyInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwupdatecompanyinfo.php"

#define NITDeleteCompanyInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwdeletecompanyinfo.php"

#define NITGetFacilityInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwgetfacilityinfo.php"

#define NITUpdateFacilityInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwupdatefacilityinfo.php"

#define NITGetStaffInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwgetstaffinfo.php"

#define NITUpdateStaffInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwupdatestaffinfo.php"

#define NITGetSPList @"http://mimamori2p1.azurewebsites.net/mgmt/zwgetsplist.php"

#define NITGetSPInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwgetspinfo.php"

#define NITUpdateSPInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwupdatespinfo.php"

#define NITGetHomeCustInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwgetcustinfo.php"

#define NITUpdateHomeCustInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwupdatecustinfo.php"

#define NITGetRoomInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwgetroominfo.php"

#define NITUpdateRoomInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwupdateroominfo.php"

#define NITDeleteRoomInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwdeleteroominfo.php"


/**　機器情報　*/
#define NITGetSSInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwgetssinfo.php"
#define NITUpdateSSInfo @"http://mimamori2p1.azurewebsites.net/mgmt/zwupdatessinfo.php"

/**
 lift   URL
 */
#define NITGetDailyDeviceInfo @"http://mimamori2p1.azurewebsites.net/zwgetdailydeviceinfo.php"

#define NITGetWeeklyDeviceInfo @"http://mimamori2p1.azurewebsites.net/zwgetweeklydeviceinfo.php"

#define NITGetMonthlyDeviceInfo @"http://mimamori2p1.azurewebsites.net/zwgetmonthlydeviceinfo.php"

#define NITGetCarememoDateList @"http://mimamori2p1.azurewebsites.net/zwgetcarememodatelist.php"

#define NITGetCarememoInfo @"http://mimamori2p1.azurewebsites.net/zwgetcarememoinfo.php"

#define NITUpdateCarememoInfo @"http://mimamori2p1.azurewebsites.net/zwupdatecarememoinfo.php"

/**
 notice   URL
 */
#define NITGetNoticeInfo @"http://mimamori2p1.azurewebsites.net/zwgetnoticeinfo.php"

#define NITGetNoticeDateList @"http://mimamori2p1.azurewebsites.net/zwgetnoticedatelist.php"

#define NITUpdateNoticeInfo @"http://mimamori2p1.azurewebsites.net/zwupdatenoticeinfo.php"


/**
 login   URL
 */

#define NITLogin @"http://mimamori2p1.azurewebsites.net/zwlogin.php"

#define NITGetZsessionInfo @"http://mimamori2p1.azurewebsites.net/zwgetzsessioninfo.php"

#define NITGetfacilityList @"http://mimamori2p1.azurewebsites.net/zwgetfacilitylist.php"





#endif /* MCommon_h */
