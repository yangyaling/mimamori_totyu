//
//  MCustTool.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/1.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHttpTool.h"

#import "MCustInfoParam.h"
#import "MCustDeleteParam.h"
#import "MCustAddParam.h"

@interface MCustTool : NSObject

/**
 *  見守り対象者を取得
 *
 */
+(void)custInfoWithParam:(MCustInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

/**
 *  見守り対象者を削除
 *
 */
+(void)custDeleteWithParam:(MCustDeleteParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;

/**
 *  見守り対象者を追加
 *
 */
+(void)custAddWithParam:(MCustAddParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;
@end
