//
//  MGroupTool.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/2.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGroupTool : NSObject

/**
 *  分组信息取得
 *
 *  @param param   请求参数
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+(void)groupInfoWithsuccess:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

@end
