//
//  MCustTool.m
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "MCustTool.h"

@implementation MCustTool


+(void)custInfoWithParam:(MCustInfoParam *)param success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    [MHttpTool postWithURL:NITGetCustInfo params:param.mj_keyValues success:^(id json) {
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

+(void)custDeleteWithParam:(MCustDeleteParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure{
    [MHttpTool postWithURL: NITDeleteCustInfo params:param.mj_keyValues success:^(id json) {
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

+(void)custAddWithParam:(MCustAddParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure{
    [MHttpTool postWithURL: NITAddCustInfo params:param.mj_keyValues success:^(id json) {
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
