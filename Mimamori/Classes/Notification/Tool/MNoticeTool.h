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
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)noticeInfoWithParam:(MNoticeInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

/**
 *  获取有通知的日期
 *
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)noticeDatesWithParam:(MNoticeDateParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

/**
 *  更新通知状态(確認必要->確認済み)
 *
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)noticeInfoUpdateWithParam:(MNoticeInfoUpdateParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;

/**
 *  上传一条通知（お知らせ/支援要請）
 *
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)noticeInfoUploadWithParam:(MNoticeInfoUploadParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;

@end
