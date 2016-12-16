//
//  MHttpTool.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/10/31.
//  Copyright © 2016年 楊亜玲. All rights reserved.
//  网络请求工具类

#import <Foundation/Foundation.h>

@interface MHttpTool : NSObject

/**
 *  发送一个post请求
 *
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+(void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个post请求（上传文件数据）
 *
 *  @param url           请求地址
 *  @param params        请求参数
 *  @param formDataArray 文件参数
 *  @param success       请求成功后的回调
 *  @param failure       请求失败后的回调
 */
+(void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个get请求
 *
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+(void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end




/**
 *  用来封装文件数据的模型
 */
@interface IWFormData : NSObject
/**
 *  文件数据
 */
@property(nonatomic, strong) NSData                                *data;
/**
 *  参数名
 */
@property (nonatomic, copy) NSString                               *name;
/**
 *  文件名
 */
@property (nonatomic, copy) NSString                               *filename;
/**
 *  文件类型
 */
@property (nonatomic, copy) NSString                               *mimeType;

@end