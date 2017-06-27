//
//  MLoginTool.m
//  Mimamori
//
//  Created by NISSAY IT on 16/10/31.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "MLoginTool.h"
#import "MHttpTool.h"

@implementation MLoginTool

/**
 *  Login
 *
 */
+(void)loginWithParam:(MLoginParam *)param success:(void (^)(MLoginResult *result))success failure:(void (^)(NSError *error))failure{
    
    [MHttpTool postWithURL:NITLogin params:param.mj_keyValues success:^(id json) {
        if (success) {
            // 字典转模型
            MLoginResult *result = [MLoginResult mj_objectWithKeyValues:json];
            success(result);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 *  セッション取得
 *
 */
+(void)sessionInfoWithParam:(MSessionInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure{
    
    [MHttpTool postWithURL:NITGetZsessionInfo params:param.mj_keyValues success:^(id json) {
        if (success) {
            // 字典数组转模型数组
            NSArray *zsessioninfo = [json objectForKey:@"zsessioninfo"];
            NSArray *tmp = [MSessionInfoResult mj_objectArrayWithKeyValuesArray:zsessioninfo];
            success(tmp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 施設情報取得
 */
+(void)getFacilityInfoWithParam:(MSessionInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure {
    [MHttpTool postWithURL:NITGetfacilityList params:param.mj_keyValues success:^(id json) {
        if (success) {
            // 字典数组转模型数组
            NSArray *facilitylist = [json objectForKey:@"facilitylist"];
            success(facilitylist);
            
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
