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
 *  获取数据
 *
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)sensorDataWithParam:(MSensorDataParam *)param type:(MSensorDataType)type success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;




@end
