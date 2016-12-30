//
//  MProfileTool.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IconModel.h"
#import "MProfileInfoParam.h"
#import "MProfileInfoUpdateParam.h"

@interface MProfileTool : NSObject

/**
 *  个人情报取得
 *
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)profileInfoWithParam:(MProfileInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;


/**
 *  个人情报更新
 *
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)profileInfoUpdateWithParam:(MProfileInfoUpdateParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;



/**
 *  图片上传
 *
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)profileInfoUpdateImageWithParam:(IconModel *)param withImageDatas:(NSArray *)images success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;
@end
