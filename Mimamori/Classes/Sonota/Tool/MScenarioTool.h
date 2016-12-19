//
//  MScenarioTool.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MScenarioListParam.h"

#import "MScenarioDeleteParam.h"

@interface MScenarioTool : NSObject

/**
 *  シナリオ一覧取得
 *
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)scenarioListWithParam:(MScenarioListParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

/**
 *  删除一个シナリオ
 *
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)scenarioDeleteWithParam:(MScenarioDeleteParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;

@end
