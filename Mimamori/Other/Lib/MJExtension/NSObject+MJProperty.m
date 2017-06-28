//
//  NSObject+MJProperty.m
//  MJExtensionExample
//
//  Created by NISSAY IT on 15/4/17.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import "NSObject+MJProperty.h"
#import "NSObject+MJKeyValue.h"
#import "NSObject+MJCoding.h"
#import "NSObject+MJClass.h"
#import "MJProperty.h"
#import "MJFoundation.h"
#import <objc/runtime.h>
#import "MJDictionaryCache.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation NSObject (Property)

static const char MJReplacedKeyFromPropertyNameKey = '\0';
static const char MJReplacedKeyFromPropertyName121Key = '\0';
static const char MJNewValueFromOldValueKey = '\0';
static const char MJObjectClassInArrayKey = '\0';

static const char MJCachedPropertiesKey = '\0';

#pragma mar
+ (NSString *)propertyKey:(NSString *)propertyName
{
    MJExtensionAssertParamNotNil2(propertyName, nil);
    
    __block NSString *key = nil;

    if ([self respondsToSelector:@selector(mj_replacedKeyFromPropertyName121:)]) {
        key = [self mj_replacedKeyFromPropertyName121:propertyName];
    }

    if ([self respondsToSelector:@selector(replacedKeyFromPropertyName121:)]) {
        key = [self performSelector:@selector(replacedKeyFromPropertyName121) withObject:propertyName];
    }
    

    if (!key) {
        [self mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            MJReplacedKeyFromPropertyName121 block = objc_getAssociatedObject(c, &MJReplacedKeyFromPropertyName121Key);
            if (block) {
                key = block(propertyName);
            }
            if (key) *stop = YES;
        }];
    }

    if (!key && [self respondsToSelector:@selector(mj_replacedKeyFromPropertyName)]) {
        key = [self mj_replacedKeyFromPropertyName][propertyName];
    }

    if (!key && [self respondsToSelector:@selector(replacedKeyFromPropertyName)]) {
        key = [self performSelector:@selector(replacedKeyFromPropertyName)][propertyName];
    }
    
    if (!key) {
        [self mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSDictionary *dict = objc_getAssociatedObject(c, &MJReplacedKeyFromPropertyNameKey);
            if (dict) {
                key = dict[propertyName];
            }
            if (key) *stop = YES;
        }];
    }
    

    if (!key) key = propertyName;
    
    return key;
}

+ (Class)propertyObjectClassInArray:(NSString *)propertyName
{
    __block id clazz = nil;
    if ([self respondsToSelector:@selector(mj_objectClassInArray)]) {
        clazz = [self mj_objectClassInArray][propertyName];
    }
 
    if ([self respondsToSelector:@selector(objectClassInArray)]) {
        clazz = [self performSelector:@selector(objectClassInArray)][propertyName];
    }
    
    if (!clazz) {
        [self mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSDictionary *dict = objc_getAssociatedObject(c, &MJObjectClassInArrayKey);
            if (dict) {
                clazz = dict[propertyName];
            }
            if (clazz) *stop = YES;
        }];
    }
    

    if ([clazz isKindOfClass:[NSString class]]) {
        clazz = NSClassFromString(clazz);
    }
    return clazz;
}

#pragma mar
+ (void)mj_enumerateProperties:(MJPropertiesEnumeration)enumeration
{
 
    NSArray *cachedProperties = [self properties];
    

    BOOL stop = NO;
    for (MJProperty *property in cachedProperties) {
        enumeration(property, &stop);
        if (stop) break;
    }
}

#pragma mark -
+ (NSMutableArray *)properties
{
    NSMutableArray *cachedProperties = [MJDictionaryCache objectForKey:NSStringFromClass(self) forDictId:&MJCachedPropertiesKey];
    
    if (cachedProperties == nil) {
        cachedProperties = [NSMutableArray array];
        
        [self mj_enumerateClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        
            unsigned int outCount = 0;
            objc_property_t *properties = class_copyPropertyList(c, &outCount);
            

            for (unsigned int i = 0; i<outCount; i++) {
                MJProperty *property = [MJProperty cachedPropertyWithProperty:properties[i]];
                // 过滤掉系统自动添加的元素
                if ([property.name isEqualToString:@"hash"]
                    || [property.name isEqualToString:@"superclass"]
                    || [property.name isEqualToString:@"description"]
                    || [property.name isEqualToString:@"debugDescription"]) {
                    continue;
                }
                property.srcClass = c;
                [property setOriginKey:[self propertyKey:property.name] forClass:self];
                [property setObjectClassInArray:[self propertyObjectClassInArray:property.name] forClass:self];
                [cachedProperties addObject:property];
            }
            

            free(properties);
        }];
        
        [MJDictionaryCache setObject:cachedProperties forKey:NSStringFromClass(self) forDictId:&MJCachedPropertiesKey];
    }
    
    return cachedProperties;
}

#pragma
+ (void)mj_setupNewValueFromOldValue:(MJNewValueFromOldValue)newValueFormOldValue
{
    objc_setAssociatedObject(self, &MJNewValueFromOldValueKey, newValueFormOldValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (id)mj_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(MJProperty *__unsafe_unretained)property{

    if ([object respondsToSelector:@selector(mj_newValueFromOldValue:property:)]) {
        return [object mj_newValueFromOldValue:oldValue property:property];
    }

    if ([self respondsToSelector:@selector(newValueFromOldValue:property:)]) {
        return [self performSelector:@selector(newValueFromOldValue:property:)  withObject:oldValue  withObject:property];
    }
    

    __block id newValue = oldValue;
    [self mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        MJNewValueFromOldValue block = objc_getAssociatedObject(c, &MJNewValueFromOldValueKey);
        if (block) {
            newValue = block(object, oldValue, property);
            *stop = YES;
        }
    }];
    return newValue;
}

#pragma mark
+ (void)mj_setupObjectClassInArray:(MJObjectClassInArray)objectClassInArray
{
    [self mj_setupBlockReturnValue:objectClassInArray key:&MJObjectClassInArrayKey];
    
    [[MJDictionaryCache dictWithDictId:&MJCachedPropertiesKey] removeAllObjects];
}

#pragma mark 
+ (void)mj_setupReplacedKeyFromPropertyName:(MJReplacedKeyFromPropertyName)replacedKeyFromPropertyName
{
    [self mj_setupBlockReturnValue:replacedKeyFromPropertyName key:&MJReplacedKeyFromPropertyNameKey];
    
    [[MJDictionaryCache dictWithDictId:&MJCachedPropertiesKey] removeAllObjects];
}

+ (void)mj_setupReplacedKeyFromPropertyName121:(MJReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121
{
    objc_setAssociatedObject(self, &MJReplacedKeyFromPropertyName121Key, replacedKeyFromPropertyName121, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [[MJDictionaryCache dictWithDictId:&MJCachedPropertiesKey] removeAllObjects];
}
@end

@implementation NSObject (MJPropertyDeprecated_v_2_5_16)
+ (void)enumerateProperties:(MJPropertiesEnumeration)enumeration
{
    [self mj_enumerateProperties:enumeration];
}

+ (void)setupNewValueFromOldValue:(MJNewValueFromOldValue)newValueFormOldValue
{
    [self mj_setupNewValueFromOldValue:newValueFormOldValue];
}

+ (id)getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained MJProperty *)property
{
    return [self mj_getNewValueFromObject:object oldValue:oldValue property:property];
}

+ (void)setupReplacedKeyFromPropertyName:(MJReplacedKeyFromPropertyName)replacedKeyFromPropertyName
{
    [self mj_setupReplacedKeyFromPropertyName:replacedKeyFromPropertyName];
}

+ (void)setupReplacedKeyFromPropertyName121:(MJReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121
{
    [self mj_setupReplacedKeyFromPropertyName121:replacedKeyFromPropertyName121];
}

+ (void)setupObjectClassInArray:(MJObjectClassInArray)objectClassInArray
{
    [self mj_setupObjectClassInArray:objectClassInArray];
}
@end

#pragma clang diagnostic pop
