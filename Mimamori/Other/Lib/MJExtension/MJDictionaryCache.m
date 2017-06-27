//
//  MJDictionaryCache.m
//  MJExtensionExample
//
//  Created by NISSAY IT on 15/8/22.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import "MJDictionaryCache.h"
#import <objc/runtime.h>

@implementation MJDictionaryCache
+ (id)setObject:(id)object forKey:(id<NSCopying>)key forDictId:(const void *)dictId
{
   
    NSMutableDictionary *dict = [self dictWithDictId:dictId];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, dictId, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    dict[key] = object;
    
    return dict;
}

+ (id)objectForKey:(id<NSCopying>)key forDictId:(const void *)dictId
{
    return [self dictWithDictId:dictId][key];
}

+ (id)dictWithDictId:(const void *)dictId
{
    return objc_getAssociatedObject(self, dictId);
}
@end
