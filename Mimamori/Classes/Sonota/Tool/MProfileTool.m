//
//  MProfileTool.m
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "MProfileTool.h"
#import "MHttpTool.h"

@implementation MProfileTool

+(void)profileInfoWithParam:(MProfileInfoParam *)param success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    [MHttpTool postWithURL:NITGetUserInfo params:param.mj_keyValues success:^(id json) {
        if (success) {
            NSArray *dateArray = [json objectForKey:@"custinfo"];
            success(dateArray);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)profileInfoUpdateWithParam:(MProfileInfoUpdateParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure{
    [MHttpTool postWithURL: NITUpdateUserInfo params:param.mj_keyValues success:^(id json) {
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
