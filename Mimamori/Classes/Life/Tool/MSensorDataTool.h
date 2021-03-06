//
//  MSensorDataTool.h
//  Mimamori
//
//  Created by NISSAY IT on 16/11/2.
//  Copyright © 2016年 NISSAY IT. All rights reserved.


#import <Foundation/Foundation.h>

#import "MSensorDataParam.h"

typedef enum{
    MSensorDataTypeDaily,
    MSensorDataTypeWeekly,
    MSensorDataTypeMontyly
}MSensorDataType;

@interface MSensorDataTool : NSObject


+(void)sensorDataWithParam:(MSensorDataParam *)param type:(MSensorDataType)type success:(void (^)(NSDictionary *dic))success failure:(void (^)(NSError *error))failure;




@end
