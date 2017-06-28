//
//  NSObject+MJClass.h
//  MJExtensionExample
//
//  Created by NISSAY IT on 15/8/11.
//  Copyright (c) 2015年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^MJClassesEnumeration)(Class c, BOOL *stop);


typedef NSArray * (^MJAllowedPropertyNames)();

typedef NSArray * (^MJAllowedCodingPropertyNames)();


typedef NSArray * (^MJIgnoredPropertyNames)();

typedef NSArray * (^MJIgnoredCodingPropertyNames)();


@interface NSObject (MJClass)

+ (void)mj_enumerateClasses:(MJClassesEnumeration)enumeration;
+ (void)mj_enumerateAllClasses:(MJClassesEnumeration)enumeration;



+ (void)mj_setupAllowedPropertyNames:(MJAllowedPropertyNames)allowedPropertyNames;


+ (NSMutableArray *)mj_totalAllowedPropertyNames;



+ (void)mj_setupIgnoredPropertyNames:(MJIgnoredPropertyNames)ignoredPropertyNames;


+ (NSMutableArray *)mj_totalIgnoredPropertyNames;



+ (void)mj_setupAllowedCodingPropertyNames:(MJAllowedCodingPropertyNames)allowedCodingPropertyNames;


+ (NSMutableArray *)mj_totalAllowedCodingPropertyNames;



+ (void)mj_setupIgnoredCodingPropertyNames:(MJIgnoredCodingPropertyNames)ignoredCodingPropertyNames;


+ (NSMutableArray *)mj_totalIgnoredCodingPropertyNames;

+ (void)mj_setupBlockReturnValue:(id (^)())block key:(const char *)key;
@end
