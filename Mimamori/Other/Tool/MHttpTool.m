//
//  MHttpTool.m
//  Mimamori
//
//  Created by NISSAY IT on 16/10/31.
//  Copyright © 2016年 NISSAY IT. All rights reserved.

#import "MHttpTool.h"

#import "AFNetworking.h"

@implementation MHttpTool


/**
 POST - > リクエスト

 */
+(void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"当前的url:%@\n%@",url,params);
  
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    
    NSMutableDictionary *pdic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSString *hostcd = [NITUserDefaults objectForKey:@"HOSTCDKEY"];
    
    NSString *staffid = [NITUserDefaults objectForKey:@"STAFFIDKEY"];
    
    [pdic setObject:staffid forKey:@"loginuser"];
    
    [pdic setObject:hostcd forKey:@"hostcd"];
    
   
    [session POST:url parameters:pdic progress:^(NSProgress * _Nonnull uploadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success([NSDictionary changeType:responseObject]);
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
        
    }];
    
}


+(void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *pdic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSString *hostcd = [NITUserDefaults objectForKey:@"HOSTCDKEY"];
    
    NSString *staffid = [NITUserDefaults objectForKey:@"STAFFIDKEY"];
    
    [pdic setObject:staffid forKey:@"loginuser"];
    
    [pdic setObject:hostcd forKey:@"hostcd"];
    
    
    [session POST:url parameters:pdic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull totalFormData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success([NSDictionary changeType:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}


+(void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    NSMutableDictionary *pdic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSString *hostcd = [NITUserDefaults objectForKey:@"HOSTCDKEY"];
    NSString *staffid = [NITUserDefaults objectForKey:@"STAFFIDKEY"];
    [pdic setObject:staffid forKey:@"loginuser"];
    [pdic setObject:hostcd forKey:@"hostcd"];
  
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    

  
    [session GET:url parameters:pdic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success([NSDictionary changeType:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}


@end


