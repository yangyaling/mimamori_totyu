//
//  NSDictionary+DeleteNull.m
//  mima_ST
//
//  Created by totyu2 on 2017/6/6.
//  Copyright © 2017年 totyu3. All rights reserved.
//

#import "NSDictionary+ZLDeleteNull.h"




/**
 データの中の（Null）   （@""）に転換する
 */
@implementation NSDictionary (ZLDeleteNull)

#pragma mark - 私有方法

+(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < keyArr.count; i ++)
        
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
        
    }
    
    return resDic;
}



+(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        
        obj = [self changeType:obj];
        
        [resArr addObject:obj];
    }
    
    return resArr;
}


+(NSString *)stringToString:(NSString *)string
{
    return string;
}

+(NSString *)nullToString
{
    return @"";
}

#pragma mark - 公有方法


/**
 各種データの種類の判断
 */
+(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}

@end
