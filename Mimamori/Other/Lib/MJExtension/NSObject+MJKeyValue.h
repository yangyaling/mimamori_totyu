//
//  NSObject+MJKeyValue.h
//  MJExtension
//
//  Created by mj on 13-8-24.
//  Copyright (c) 2013年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtensionConst.h"
#import <CoreData/CoreData.h>
#import "MJProperty.h"


@protocol MJKeyValue <NSObject>
@optional

+ (NSArray *)mj_allowedPropertyNames;


+ (NSArray *)mj_ignoredPropertyNames;


+ (NSDictionary *)mj_replacedKeyFromPropertyName;


+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName;


+ (NSDictionary *)mj_objectClassInArray;


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property;


- (void)mj_keyValuesDidFinishConvertingToObject;


- (void)mj_objectDidFinishConvertingToKeyValues;
@end

@interface NSObject (MJKeyValue) <MJKeyValue>
#pragma mark -

+ (NSError *)mj_error;


+ (void)mj_referenceReplacedKeyWhenCreatingKeyValues:(BOOL)reference;

#pragma mark -

- (instancetype)mj_setKeyValues:(id)keyValues;


- (instancetype)mj_setKeyValues:(id)keyValues context:(NSManagedObjectContext *)context;


- (NSMutableDictionary *)mj_keyValues;
- (NSMutableDictionary *)mj_keyValuesWithKeys:(NSArray *)keys;
- (NSMutableDictionary *)mj_keyValuesWithIgnoredKeys:(NSArray *)ignoredKeys;


+ (NSMutableArray *)mj_keyValuesArrayWithObjectArray:(NSArray *)objectArray;
+ (NSMutableArray *)mj_keyValuesArrayWithObjectArray:(NSArray *)objectArray keys:(NSArray *)keys;
+ (NSMutableArray *)mj_keyValuesArrayWithObjectArray:(NSArray *)objectArray ignoredKeys:(NSArray *)ignoredKeys;

#pragma mark -

+ (instancetype)mj_objectWithKeyValues:(id)keyValues;


+ (instancetype)mj_objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context;


+ (instancetype)mj_objectWithFilename:(NSString *)filename;


+ (instancetype)mj_objectWithFile:(NSString *)file;



+ (NSMutableArray *)mj_objectArrayWithKeyValuesArray:(id)keyValuesArray;

+ (NSMutableArray *)mj_objectArrayWithKeyValuesArray:(id)keyValuesArray context:(NSManagedObjectContext *)context;

+ (NSMutableArray *)mj_objectArrayWithFilename:(NSString *)filename;


+ (NSMutableArray *)mj_objectArrayWithFile:(NSString *)file;

#pragma mark -

- (NSData *)mj_JSONData;

- (id)mj_JSONObject;

- (NSString *)mj_JSONString;
@end

@interface NSObject (MJKeyValueDeprecated_v_2_5_16)
- (instancetype)setKeyValues:(id)keyValue MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (instancetype)setKeyValues:(id)keyValues error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (instancetype)setKeyValues:(id)keyValues context:(NSManagedObjectContext *)context MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (instancetype)setKeyValues:(id)keyValues context:(NSManagedObjectContext *)context error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (void)referenceReplacedKeyWhenCreatingKeyValues:(BOOL)reference MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (NSMutableDictionary *)keyValues MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (NSMutableDictionary *)keyValuesWithError:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (NSMutableDictionary *)keyValuesWithKeys:(NSArray *)keys MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (NSMutableDictionary *)keyValuesWithKeys:(NSArray *)keys error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (NSMutableDictionary *)keyValuesWithIgnoredKeys:(NSArray *)ignoredKeys MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (NSMutableDictionary *)keyValuesWithIgnoredKeys:(NSArray *)ignoredKeys error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray keys:(NSArray *)keys MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray keys:(NSArray *)keys error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray ignoredKeys:(NSArray *)ignoredKeys MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray ignoredKeys:(NSArray *)ignoredKeys error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (instancetype)objectWithKeyValues:(id)keyValues MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (instancetype)objectWithKeyValues:(id)keyValues error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (instancetype)objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (instancetype)objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (instancetype)objectWithFilename:(NSString *)filename MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (instancetype)objectWithFilename:(NSString *)filename error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (instancetype)objectWithFile:(NSString *)file MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (instancetype)objectWithFile:(NSString *)file error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray context:(NSManagedObjectContext *)context MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)objectArrayWithKeyValuesArray:(id)keyValuesArray context:(NSManagedObjectContext *)context error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)objectArrayWithFilename:(NSString *)filename MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)objectArrayWithFilename:(NSString *)filename error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)objectArrayWithFile:(NSString *)file MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
+ (NSMutableArray *)objectArrayWithFile:(NSString *)file error:(NSError **)error MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (NSData *)JSONData MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (id)JSONObject MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
- (NSString *)JSONString MJExtensionDeprecated("请在方法名前面加上mj_前缀，使用mj_***");
@end
