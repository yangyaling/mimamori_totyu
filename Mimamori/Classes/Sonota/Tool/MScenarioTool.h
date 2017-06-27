//
//  MScenarioTool.h
//  Mimamori
//
//  Created by NISSAY IT on 16/11/1.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MScenarioListParam.h"

#import "MScenarioDeleteParam.h"

@interface MScenarioTool : NSObject

/**
 *  シナリオ一覧を取得
 *
 */
+(void)scenarioListWithParam:(MScenarioListParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

/**
 *  シナリオ を削除
 */
+(void)scenarioDeleteWithParam:(MScenarioDeleteParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;



/**
 *  シナリオ を更新
 */
+(void)sensorUpdateWithParam:(MScenarioListParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;

@end
