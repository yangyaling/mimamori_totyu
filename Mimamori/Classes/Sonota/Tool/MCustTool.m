//
//  MCustTool.m
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "MCustTool.h"

@implementation MCustTool

/**
 *  見守り対象者を取得
 *
 */
+(void)custInfoWithParam:(MCustInfoParam *)param success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    [MHttpTool postWithURL:NITGetCustList params:param.mj_keyValues success:^(id json) {
        if (success) {
            NSArray *dateArray = [json objectForKey:@"custlist"];
            success(dateArray);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 *  見守り対象者を削除
 *
 */
+(void)custDeleteWithParam:(MCustDeleteParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure{
    [MHttpTool postWithURL: NITDeleteCustList params:param.mj_keyValues success:^(id json) {
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
 *  見守り対象者を追加
 *
 */
+(void)custAddWithParam:(MCustAddParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure{
    [MHttpTool postWithURL: NITAddCustList params:param.mj_keyValues success:^(id json) {
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
