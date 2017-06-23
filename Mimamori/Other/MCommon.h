//
//  MCommon.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#ifndef MCommon_h
#define MCommon_h


#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)


#define NITDataPath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Data"]


#define NITDocumentDirectory NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#define NITFilePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject


#define NITColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define NITColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1.0]

#define NITRandomColor NITColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define NITNetwork [UIApplication sharedApplication].networkActivityIndicatorVisible

#ifdef DEBUG //
#define NITLog(...) NSLog(__VA_ARGS__)
#else
#define NITLog(...)
#endif

#define NITNotificationCenter [NSNotificationCenter defaultCenter]

// UserDefaults
#define NITUserDefaults [NSUserDefaults standardUserDefaults]

#define NITScreenW [UIScreen mainScreen].bounds.size.width
#define NITScreenH [UIScreen mainScreen].bounds.size.height

#define NSNullJudge(str) (str)==[NSNull null] ? @"" : (str)

#define WindowView [UIApplication sharedApplication].windows.lastObject


#import "AnimationView.h"




#define TextSelectColor NITColor(253, 164, 181)

#define OtherEnabledCellBGColor NITColor(251, 140, 160)

#define TextFieldNormalColor NITColor(235, 235, 241)

/**
 sonota   URL
 */
#define NITUpdatePassword @"http://mimamori2p1hb.azurewebsites.net/zwupdatepassword.php"

#define NITUpdateUserInfo @"http://mimamori2p1hb.azurewebsites.net/zwupdateuserinfo.php"


#define NITGetUserInfo @"http://mimamori2p1hb.azurewebsites.net/zwgetuserinfo.php"


#define NITGetCustList @"http://mimamori2p1hb.azurewebsites.net/zwgetcustlist.php"

#define NITDeleteCustList @"http://mimamori2p1hb.azurewebsites.net/zwdeletecust.php"

#define NITAddCustList @"http://mimamori2p1hb.azurewebsites.net/zwaddcust.php"



#define NITGetCustInfo @"http://mimamori2p1hb.azurewebsites.net/zwgetcustinfo.php"

#define NITUpdateCustInfo @"http://mimamori2p1hb.azurewebsites.net/zwupdatecustinfo.php"

#define NITUploadpic @"http://mimamori2p1hb.azurewebsites.net/upload/zwuploadpic.php"


#define NITGetScenarioList @"http://mimamori2p1hb.azurewebsites.net/zwgetsslist.php"

#define NITUpdateSensorInfo @"http://mimamori2p1hb.azurewebsites.net/zwupdatenodeplaceinfo.php"


#define NITDeleteScenario @"http://mimamori2p1hb.azurewebsites.net/zwdeletescenarioinfo.php"

#define NITGetGroupInfo @"http://mimamori2p1hb.azurewebsites.net/zwgetgroupinfo.php"

#define NITGetScenarioInfo @"http://mimamori2p1hb.azurewebsites.net/zwgetscenariodtlinfo.php"

#define NITUpdateScenarioInfo @"http://mimamori2p1hb.azurewebsites.net/zwupdatescenarioinfo.php"



/*Master*/
#define NITGetNLInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwgetnlinfo.php"

#define NITUpdateNLInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwupdatenlinfo.php"

#define NITDeleteNLInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwdeletenlinfo.php"

#define NITGetCompanyInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwgetcompanyinfo.php"

#define NITUpdateCompanyInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwupdatecompanyinfo.php"

#define NITDeleteCompanyInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwdeletecompanyinfo.php"

#define NITGetFacilityInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwgetfacilityinfo.php"

#define NITUpdateFacilityInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwupdatefacilityinfo.php"

#define NITGetStaffInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwgetstaffinfo.php"

#define NITUpdateStaffInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwupdatestaffinfo.php"

#define NITDeleteStaffInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwdeletestaffinfo.php"

#define NITGetSPList @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwgetsplist.php"

#define NITDeleteSPInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwdeletespinfo.php"

#define NITGetSPInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwgetspinfo.php"

#define NITUpdateSPInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwupdatespinfo.php"

#define NITGetHomeCustInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwgetcustinfo.php"

#define NITUpdateHomeCustInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwupdatecustinfo.php"

#define NITDeleteHomeCustInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwdeletecustinfo.php"

#define NITGetRoomInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwgetroominfo.php"

#define NITUpdateRoomInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwupdateroominfo.php"

#define NITDeleteRoomInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwdeleteroominfo.php"


/**　機器情報　*/
#define NITGetSSInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwgetssinfo.php"
#define NITUpdateSSInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwupdatessinfo.php"
#define NITDeleteSSInfo @"http://mimamori2p1hb.azurewebsites.net/mgmt/zwdeletessinfo.php"

/**
 lift   URL
 */
#define NITGetDailyDeviceInfo @"http://mimamori2p1hb.azurewebsites.net/zwgetdailydeviceinfo.php"

#define NITGetWeeklyDeviceInfo @"http://mimamori2p1hb.azurewebsites.net/zwgetweeklydeviceinfo.php"

#define NITGetMonthlyDeviceInfo @"http://mimamori2p1hb.azurewebsites.net/zwgetmonthlydeviceinfo.php"

#define NITGetCarememoDateList @"http://mimamori2p1hb.azurewebsites.net/zwgetcarememodatelist.php"

#define NITGetCarememoInfo @"http://mimamori2p1hb.azurewebsites.net/zwgetcarememoinfo.php"

#define NITUpdateCarememoInfo @"http://mimamori2p1hb.azurewebsites.net/zwupdatecarememoinfo.php"

/**
 notice   URL
 */
#define NITGetNoticeInfo @"http://mimamori2p1hb.azurewebsites.net/zwgetnoticeinfo.php"

#define NITGetNoticeDateList @"http://mimamori2p1hb.azurewebsites.net/zwgetnoticedatelist.php"

#define NITUpdateNoticeInfo @"http://mimamori2p1hb.azurewebsites.net/zwupdatenoticeinfo.php"


/**
 login   URL
 */

#define NITLogin @"http://mimamori2p1hb.azurewebsites.net/zwlogin.php"

#define NITGetZsessionInfo @"http://mimamori2p1hb.azurewebsites.net/zwgetzsessioninfo.php"

#define NITGetfacilityList @"http://mimamori2p1hb.azurewebsites.net/zwgetfacilitylist.php"





#endif /* MCommon_h */
