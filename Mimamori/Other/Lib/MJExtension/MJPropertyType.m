//
//  MJPropertyType.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014年 NISSAY IT. All rights reserved.
//

#import "MJPropertyType.h"
#import "MJExtension.h"
#import "MJFoundation.h"
#import "MJExtensionConst.h"
#import "MJDictionaryCache.h"

@implementation MJPropertyType

+ (instancetype)cachedTypeWithCode:(NSString *)code
{
    MJExtensionAssertParamNotNil2(code, nil);
    
    static const char MJCachedTypesKey = '\0';
    
    MJPropertyType *type = [MJDictionaryCache objectForKey:code forDictId:&MJCachedTypesKey];
    if (type == nil) {
        type = [[self alloc] init];
        type.code = code;
        [MJDictionaryCache setObject:type forKey:code forDictId:&MJCachedTypesKey];
    }
    return type;
}

#pragma mark - 
- (void)setCode:(NSString *)code
{
    _code = code;
    
    MJExtensionAssertParamNotNil(code);
    
    if ([code isEqualToString:MJPropertyTypeId]) {
        _idType = YES;
    } else if (code.length == 0) {
        _KVCDisabled = YES;
    } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
     
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        _typeClass = NSClassFromString(_code);
        _fromFoundation = [MJFoundation isClassFromFoundation:_typeClass];
        _numberType = [_typeClass isSubclassOfClass:[NSNumber class]];
        
    } else if ([code isEqualToString:MJPropertyTypeSEL] ||
               [code isEqualToString:MJPropertyTypeIvar] ||
               [code isEqualToString:MJPropertyTypeMethod]) {
        _KVCDisabled = YES;
    }
    

    NSString *lowerCode = _code.lowercaseString;
    NSArray *numberTypes = @[MJPropertyTypeInt, MJPropertyTypeShort, MJPropertyTypeBOOL1, MJPropertyTypeBOOL2, MJPropertyTypeFloat, MJPropertyTypeDouble, MJPropertyTypeLong, MJPropertyTypeLongLong, MJPropertyTypeChar];
    if ([numberTypes containsObject:lowerCode]) {
        _numberType = YES;
        
        if ([lowerCode isEqualToString:MJPropertyTypeBOOL1]
            || [lowerCode isEqualToString:MJPropertyTypeBOOL2]) {
            _boolType = YES;
        }
    }
}
@end
