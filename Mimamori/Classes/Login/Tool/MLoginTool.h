//
//  MLoginTool.h
//  Mimamori
//
//  Created by NISSAY IT on 16/10/31.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLoginParam.h"
#import "MLoginResult.h"

#import "MSessionInfoParam.h"
#import "MSessionInfoResult.h"

@interface MLoginTool : NSObject

/**
 *  Login
 *
 */
+(void)loginWithParam:(MLoginParam *)param success:(void (^)(MLoginResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  セッション取得
 *
 */
+(void)sessionInfoWithParam:(MSessionInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;


/**
 施設情報取得
 */
+(void)getFacilityInfoWithParam:(MSessionInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

@end
