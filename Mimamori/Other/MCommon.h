//
//  MCommon.h
//  Mimamori
//
//  Created by NISSAY IT on 16/11/1.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
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
#define NITUpdatePassword @"http://mimamoriapp.chinacloudsites.cn/zwupdatepassword.php"

#define NITUpdateUserInfo @"http://mimamoriapp.chinacloudsites.cn/zwupdateuserinfo.php"


#define NITGetUserInfo @"http://mimamoriapp.chinacloudsites.cn/zwgetuserinfo.php"


#define NITGetCustList @"http://mimamoriapp.chinacloudsites.cn/zwgetcustlist.php"

#define NITDeleteCustList @"http://mimamoriapp.chinacloudsites.cn/zwdeletecust.php"

#define NITAddCustList @"http://mimamoriapp.chinacloudsites.cn/zwaddcust.php"



#define NITGetCustInfo @"http://mimamoriapp.chinacloudsites.cn/zwgetcustinfo.php"

#define NITUpdateCustInfo @"http://mimamoriapp.chinacloudsites.cn/zwupdatecustinfo.php"

#define NITUploadpic @"http://mimamoriapp.chinacloudsites.cn/upload/zwuploadpic.php"


#define NITGetScenarioList @"http://mimamoriapp.chinacloudsites.cn/zwgetsslist.php"

#define NITUpdateSensorInfo @"http://mimamoriapp.chinacloudsites.cn/zwupdatenodeplaceinfo.php"


#define NITDeleteScenario @"http://mimamoriapp.chinacloudsites.cn/zwdeletescenarioinfo.php"

#define NITGetGroupInfo @"http://mimamoriapp.chinacloudsites.cn/zwgetgroupinfo.php"

#define NITGetScenarioInfo @"http://mimamoriapp.chinacloudsites.cn/zwgetscenariodtlinfo.php"

#define NITUpdateScenarioInfo @"http://mimamoriapp.chinacloudsites.cn/zwupdatescenarioinfo.php"



/*Master*/
#define NITGetNLInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwgetnlinfo.php"

#define NITUpdateNLInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwupdatenlinfo.php"

#define NITDeleteNLInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwdeletenlinfo.php"

#define NITGetCompanyInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwgetcompanyinfo.php"

#define NITUpdateCompanyInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwupdatecompanyinfo.php"

#define NITDeleteCompanyInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwdeletecompanyinfo.php"

#define NITGetFacilityInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwgetfacilityinfo.php"

#define NITUpdateFacilityInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwupdatefacilityinfo.php"

#define NITGetStaffInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwgetstaffinfo.php"

#define NITUpdateStaffInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwupdatestaffinfo.php"

#define NITDeleteStaffInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwdeletestaffinfo.php"

#define NITGetSPList @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwgetsplist.php"

#define NITDeleteSPInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwdeletespinfo.php"

#define NITGetSPInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwgetspinfo.php"

#define NITUpdateSPInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwupdatespinfo.php"

#define NITGetHomeCustInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwgetcustinfo.php"

#define NITUpdateHomeCustInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwupdatecustinfo.php"

#define NITDeleteHomeCustInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwdeletecustinfo.php"
  
#define NITGetRoomInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwgetroominfo.php"

#define NITUpdateRoomInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwupdateroominfo.php"

#define NITDeleteRoomInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwdeleteroominfo.php"


/**　機器情報　*/
#define NITGetSSInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwgetssinfo.php"
#define NITUpdateSSInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwupdatessinfo.php"
#define NITDeleteSSInfo @"http://mimamoriapp.chinacloudsites.cn/mgmt/zwdeletessinfo.php"

/**
 lift   URL
 */
#define NITGetDailyDeviceInfo @"http://mimamoriapp.chinacloudsites.cn/zwgetdailydeviceinfo.php"

#define NITGetWeeklyDeviceInfo @"http://mimamoriapp.chinacloudsites.cn/zwgetweeklydeviceinfo.php"

#define NITGetMonthlyDeviceInfo @"http://mimamoriapp.chinacloudsites.cn/zwgetmonthlydeviceinfo.php"

#define NITGetCarememoDateList @"http://mimamoriapp.chinacloudsites.cn/zwgetcarememodatelist.php"

#define NITGetCarememoInfo @"http://mimamoriapp.chinacloudsites.cn/zwgetcarememoinfo.php"

#define NITUpdateCarememoInfo @"http://mimamoriapp.chinacloudsites.cn/zwupdatecarememoinfo.php"

/**
 notice   URL
 */
#define NITGetNoticeInfo @"http://mimamoriapp.chinacloudsites.cn/zwgetnoticeinfo.php"

#define NITGetNoticeDateList @"http://mimamoriapp.chinacloudsites.cn/zwgetnoticedatelist.php"

#define NITUpdateNoticeInfo @"http://mimamoriapp.chinacloudsites.cn/zwupdatenoticeinfo.php"


/**
 login   URL
 */

#define NITLogin @"http://mimamoriapp.chinacloudsites.cn/zwlogin.php"

#define NITGetZsessionInfo @"http://mimamoriapp.chinacloudsites.cn/zwgetzsessioninfo.php"

#define NITGetfacilityList @"http://mimamoriapp.chinacloudsites.cn/zwgetfacilitylist.php"





#endif /* MCommon_h */
