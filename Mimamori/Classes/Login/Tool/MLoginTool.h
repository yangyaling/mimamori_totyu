//
//  MLoginTool.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/10/31.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLoginParam.h"
#import "MLoginResult.h"

#import "MSessionInfoParam.h"
#import "MSessionInfoResult.h"

@interface MLoginTool : NSObject

/**
 *  登录
 *
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)loginWithParam:(MLoginParam *)param success:(void (^)(MLoginResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  セッション取得
 *
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)sessionInfoWithParam:(MSessionInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;


+(void)getFacilityInfoWithParam:(MSessionInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

@end
