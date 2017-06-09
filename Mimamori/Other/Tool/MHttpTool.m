//
//  MHttpTool.m
//  Mimamori
//
//  Created by 楊亜玲 on 16/10/31.
//  Copyright © 2016年 楊亜玲. All rights reserved.

#import "MHttpTool.h"

#import "AFNetworking.h"




@implementation MHttpTool


+(void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    // 1.创建请求管理对象
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
//    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/plain", @"text/javascript",@"application/x-json",@"text/html", nil];
    
//    ((AFJSONResponseSerializer *)session.responseSerializer).removesKeysWithNullValues = YES;
    
    NSMutableDictionary *pdic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSString *hostcd = [NITUserDefaults objectForKey:@"HOSTCDKEY"];
    
    [pdic setObject:hostcd forKey:@"hostcd"];
    
    // 2.发送请求
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
    
    // 1.创建请求管理对象
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSMutableDictionary *pdic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSString *hostcd = [NITUserDefaults objectForKey:@"HOSTCDKEY"];
    
    [pdic setObject:hostcd forKey:@"hostcd"];
//    ((AFJSONResponseSerializer *)session.responseSerializer).removesKeysWithNullValues = YES;
    // 2.发送请求
    [session POST:url parameters:pdic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull totalFormData) {
        
//        for (NSData *formData in formDataArray) {
//            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];

//        NSData *data = formDataArray[0];
        
            //上传文件参数
//        [totalFormData appendPartWithFileData:data name:@"photo" fileName:@"HeaderImage.jpeg" mimeType:@"image/jpeg"];
//        }
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
    
    //value	__NSCFString *	@"http://mimamori2.azurewebsites.net/upload/0002.jpg"	0x00000001704579d0
    //[0]	(null)	@"picpath" : @"http://mimamori2.azurewebsites.net/upload/0002.jpg"
    //value	__NSCFString *	@"http://mimamori2.azurewebsites.net/upload/0002.jpg"	0x0000000170058f00
    
}


+(void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    NSMutableDictionary *pdic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSString *hostcd = [NITUserDefaults objectForKey:@"HOSTCDKEY"];
    
    [pdic setObject:hostcd forKey:@"hostcd"];
    // 1.创建请求管理对象
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
//    ((AFJSONResponseSerializer *)session.responseSerializer).removesKeysWithNullValues = YES;
    //session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/plain", @"text/javascript",@"application/x-json",@"text/html", nil];
    
    // 2.发送请求
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


@implementation IWFormData

@end

