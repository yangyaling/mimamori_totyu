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
 */
+(void)profileInfoWithParam:(MProfileInfoParam *)param success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;


/**
 */
+(void)profileInfoUpdateWithParam:(MProfileInfoUpdateParam *)param success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;



/**
 */
+(void)profileInfoUpdateImageWithParam:(IconModel *)param withImageDatas:(NSArray *)images success:(void (^)(NSString *code))success failure:(void (^)(NSError *error))failure;
@end
