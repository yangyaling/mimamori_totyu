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

+(void)scenarioListWithParam:(MScenarioListParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure{
    [MHttpTool postWithURL:NITGetScenarioList params:param.mj_keyValues success:^(id json) {
        if (success) {
            NSArray *dateArray = [json objectForKey:@"scenariolist"];
            success(dateArray);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

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


@end
