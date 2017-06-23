//
//  MNoticeTool.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//  封装 关于通知请求的工具类

#import <Foundation/Foundation.h>

#import "MNoticeInfoParam.h"
#import "MNoticeInfoResult.h"

#import "MNoticeDateParam.h"

#import "MNoticeInfoUpdateParam.h"

#import "MNoticeInfoUploadParam.h"



@interface MNoticeTool : NSObject

/**
 *  获取通知
 *
 */
+(void)noticeInfoWithParam:(MNoticeInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

/**
 *
 *通知の期日を得る
 */
+(void)noticeDatesWithParam:(MNoticeDateParam *)param success:(void (^)(NSDictionary *dic))success failure:(void (^)(NSError *error))failure;

/**
 *  通知状態に更新(確認必要->確認済み)
 */
+(void)noticeInfoUpdateWithParam:(MNoticeInfoUpdateParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;

/**
 *  アップロードのお知らせ（お知らせ/支援要請）
 *
 */
+(void)noticeInfoUploadWithParam:(MNoticeInfoUploadParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;

@end
