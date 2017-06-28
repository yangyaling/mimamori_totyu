//
//  NSObject+MJCoding.h
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014年 NISSAY IT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtensionConst.h"


@protocol MJCoding <NSObject>
@optional

+ (NSArray *)mj_allowedCodingPropertyNames;

+ (NSArray *)mj_ignoredCodingPropertyNames;
@end

@interface NSObject (MJCoding) <MJCoding>

- (void)mj_decode:(NSCoder *)decoder;

- (void)mj_encode:(NSCoder *)encoder;
@end


#define MJCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self mj_decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self mj_encode:encoder]; \
}

#define MJExtensionCodingImplementation MJCodingImplementation
