//
//  MScenarioTool.m
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "MScenarioTool.h"
#import "MHttpTool.h"

@implementation MScenarioTool
/**
 *  シナリオ一覧を取得
 *
 */
+(void)scenarioListWithParam:(MScenarioListParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure{
    
    [MHttpTool postWithURL:NITGetScenarioList params:param.mj_keyValues success:^(id json) {
        if (success) {
            NSMutableArray *arr = [NSMutableArray new];
            [arr addObject:json];
//            NSArray *dateArray = [json objectForKey:@"scenariolist"];
            success(arr);
        }
        
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    //[1]	(null)	@"sensorplacelist" : @"7 elements"
}
/**
 *  シナリオ を削除
 */
+(void)scenarioDeleteWithParam:(MScenarioDeleteParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure{
    [MHttpTool postWithURL: NITDeleteScenario params:param.mj_keyValues success:^(id json) {
        if (success) {
            NSString *code = [json objectForKey:@"code"];
            success(code);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  シナリオ を更新
 */
+(void)sensorUpdateWithParam:(MScenarioListParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure {
    [MHttpTool postWithURL:NITUpdateSensorInfo params:param.mj_keyValues success:^(id json) {
        if (success) {
            NSString *code = [json objectForKey:@"code"];
            success(code);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
