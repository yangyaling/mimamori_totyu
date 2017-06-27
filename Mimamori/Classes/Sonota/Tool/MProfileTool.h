//
//  MProfileTool.h
//  Mimamori
//
//  Created by NISSAY IT on 16/11/1.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IconModel.h"
#import "MProfileInfoParam.h"
#import "MProfileInfoUpdateParam.h"

@interface MProfileTool : NSObject

/**
 
  見守り対象者情报を取得

 */
+(void)profileInfoWithParam:(MProfileInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

/**
 
 見守り対象者情报を更新
 
 */
+(void)profileInfoUpdateWithParam:(MProfileInfoUpdateParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;



/**
 
 見守り対象者画像を更新
 
 */
+(void)profileInfoUpdateImageWithParam:(IconModel *)param withImageDatas:(NSArray *)images success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;
@end
