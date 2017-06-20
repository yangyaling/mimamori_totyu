//
//  MSensorDataTool.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/2.
//  Copyright © 2016年 totyu3. All rights reserved.
//  封装 关于数据网络请求的类

#import <Foundation/Foundation.h>

#import "MSensorDataParam.h"

typedef enum{
    MSensorDataTypeDaily,
    MSensorDataTypeWeekly,
    MSensorDataTypeMontyly
}MSensorDataType;

@interface MSensorDataTool : NSObject

/**
 *  Get  （Daily、Weekly、Montyly）   Device Info
 */
+(void)sensorDataWithParam:(MSensorDataParam *)param type:(MSensorDataType)type success:(void (^)(NSDictionary *dic))success failure:(void (^)(NSError *error))failure;




@end
