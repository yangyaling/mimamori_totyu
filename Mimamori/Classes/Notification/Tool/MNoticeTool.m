//
//  MNoticeTool.m
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "MNoticeTool.h"
#import "MHttpTool.h"

@implementation MNoticeTool

+(void)noticeInfoWithParam:(MNoticeInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure{
    [MHttpTool postWithURL:NITGetNoticeInfo params:param.mj_keyValues success:^(id json) {
        if (success) {
           
            NSArray *noticesArray = [MNoticeInfoResult mj_objectArrayWithKeyValuesArray:[json objectForKey:@"notices"]];
            success(noticesArray);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)noticeDatesWithParam:(MNoticeDateParam *)param success:(void (^)(NSDictionary *dic))success failure:(void (^)(NSError *error))failure {
    [MHttpTool postWithURL:NITGetNoticeDateList params:param.mj_keyValues success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)noticeInfoUpdateWithParam:(MNoticeInfoUpdateParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure{
    [MHttpTool postWithURL:NITUpdateNoticeInfo params:param.mj_keyValues success:^(id json) {
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

+(void)noticeInfoUploadWithParam:(MNoticeInfoUploadParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure{
    [MHttpTool postWithURL:NITUpdateNoticeInfo params:param.mj_keyValues success:^(id json) {
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
