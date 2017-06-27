//
//  MProfileTool.m
//  Mimamori
//
//  Created by NISSAY IT on 16/11/1.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "MProfileTool.h"
#import "MHttpTool.h"

@implementation MProfileTool
/**
 
 見守り対象者情报を取得
 
 */
+(void)profileInfoWithParam:(MProfileInfoParam *)param success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    [MHttpTool postWithURL:NITGetCustInfo params:param.mj_keyValues success:^(id json) {
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
/**
 
 見守り対象者情报を更新
 
 */
+(void)profileInfoUpdateWithParam:(MProfileInfoUpdateParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure{
    [MHttpTool postWithURL: NITUpdateCustInfo params:param.mj_keyValues success:^(id json) {
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
 
 見守り対象者画像を更新
 
 */
+(void)profileInfoUpdateImageWithParam:(IconModel *)param withImageDatas:(NSArray *)images success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure {
    
    [MHttpTool postWithURL:NITUploadpic params:param.mj_keyValues formDataArray:images success:^(id json) {
        if (success) {
            NSString *path = [json objectForKey:@"picpath"];
            NSString *code = [json objectForKey:@"code"];
            NSString *con = [NSString stringWithFormat:@"%@\n%@",code,path];
            success(con);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
     
@end
