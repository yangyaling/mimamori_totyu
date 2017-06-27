//
//  MSensorDataTool.m
//  Mimamori
//
//  Created by NISSAY IT on 16/11/2.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "MSensorDataTool.h"
#import "MHttpTool.h"

@implementation MSensorDataTool

/**
 *  POST ->  （Daily、Weekly、Montyly）   デバイス情報
 */
+(void)sensorDataWithParam:(MSensorDataParam *)param type:(MSensorDataType)type success:(void (^)(NSDictionary *dic))success failure:(void (^)(NSError *error))failure{
    NSString *url;
    switch (type) {
            
        case MSensorDataTypeDaily:
            url = NITGetDailyDeviceInfo;
            break;
        case MSensorDataTypeWeekly:
            url = NITGetWeeklyDeviceInfo;
            break;
        case MSensorDataTypeMontyly:
            url = NITGetMonthlyDeviceInfo;
            break;
        default:
            break;
    }
    
    [MHttpTool postWithURL:url params:param.mj_keyValues success:^(id json) {
        if (success) {
            NSDictionary *tmpdic = json;
            success(tmpdic);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
