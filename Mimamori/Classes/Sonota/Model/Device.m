//
//  Device.m
//  Mimamori
//
//  Created by NISSAY IT on 16/9/14.
//  Copyright © 2016年 NISSAY IT. All rights reserved.
//

#import "Device.h"


@implementation Device

- (void)encodeWithCoder:(NSCoder*)encoder
{
    unsigned int count;
    Ivar* ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char* name = ivar_getName(ivar);
        NSString* strName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:strName];
        [encoder encodeObject:value forKey:strName];
    }
    free(ivars);
}


- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init]) {
        unsigned int count;
        Ivar* ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            const char* name = ivar_getName(ivar);
            NSString* strName = [NSString stringWithUTF8String:name];
            id value = [decoder decodeObjectForKey:strName];
            [self setValue:value forKey:strName];
        }
        free(ivars);
    }
    return self;
}

@end
