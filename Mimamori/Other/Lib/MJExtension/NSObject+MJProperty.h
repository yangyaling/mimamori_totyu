//
//  NSObject+MJProperty.h
//  MJExtensionExample
//
//  Created by NISSAY IT on 15/4/17.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtensionConst.h"

@class MJProperty;


typedef void (^MJPropertiesEnumeration)(MJProperty *property, BOOL *stop);


typedef NSDictionary * (^MJReplacedKeyFromPropertyName)();
typedef NSString * (^MJReplacedKeyFromPropertyName121)(NSString *propertyName);

typedef NSDictionary * (^MJObjectClassInArray)();

typedef id (^MJNewValueFromOldValue)(id object, id oldValue, MJProperty *property);


@interface NSObject (MJProperty)

+ (void)mj_enumerateProperties:(MJPropertiesEnumeration)enumeration;


+ (void)mj_setupNewValueFromOldValue:(MJNewValueFromOldValue)newValueFormOldValue;
+ (id)mj_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained MJProperty *)property;


+ (void)mj_setupReplacedKeyFromPropertyName:(MJReplacedKeyFromPropertyName)replacedKeyFromPropertyName;

+ (void)mj_setupReplacedKeyFromPropertyName121:(MJReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121;


+ (void)mj_setupObjectClassInArray:(MJObjectClassInArray)objectClassInArray;
@end

@interface NSObject (MJPropertyDeprecated_v_2_5_16)
+ (void)enumerateProperties:(MJPropertiesEnumeration)enumeration MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (void)setupNewValueFromOldValue:(MJNewValueFromOldValue)newValueFormOldValue MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (id)getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained MJProperty *)property MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (void)setupReplacedKeyFromPropertyName:(MJReplacedKeyFromPropertyName)replacedKeyFromPropertyName MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (void)setupReplacedKeyFromPropertyName121:(MJReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121 MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (void)setupObjectClassInArray:(MJObjectClassInArray)objectClassInArray MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
@end
