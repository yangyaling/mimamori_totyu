//
//  MJDictionaryCache.h
//  MJExtensionExample
//
//  Created by NISSAY IT on 15/8/22.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJDictionaryCache : NSObject

+ (id)setObject:(id)object forKey:(id<NSCopying>)key forDictId:(const void *)dictId;


+ (id)objectForKey:(id<NSCopying>)key forDictId:(const void *)dictId;


+ (id)dictWithDictId:(const void *)dictId;
@end
