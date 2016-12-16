//
//  MGroupTool.m
//  Mimamori
//
//  Created by 楊亜玲 on 16/11/2.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "MGroupTool.h"
#import "MHttpTool.h"

@implementation MGroupTool

+(void)groupInfoWithsuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    [MHttpTool postWithURL:@"http://mimamori.azurewebsites.net/zwgetgroupinfo.php" params:nil success:^(id json) {
        if (success) {
            NSArray *dateArray = [json objectForKey:@"groupinfo"];
            success(dateArray);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
