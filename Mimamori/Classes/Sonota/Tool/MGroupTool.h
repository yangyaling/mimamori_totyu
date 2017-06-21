//
//  MGroupTool.h
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/2.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGroupTool : NSObject

+(void)groupInfoWithsuccess:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

@end
