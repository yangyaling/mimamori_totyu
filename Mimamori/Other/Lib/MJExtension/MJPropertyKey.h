//
//  MJPropertyKey.h
//  MJExtensionExample
//
//  Created by NISSAY IT on 15/8/11.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MJPropertyKeyTypeDictionary = 0, 
    MJPropertyKeyTypeArray
} MJPropertyKeyType;


@interface MJPropertyKey : NSObject

@property (copy,   nonatomic) NSString *name;

@property (assign, nonatomic) MJPropertyKeyType type;

- (id)valueInObject:(id)object;

@end
