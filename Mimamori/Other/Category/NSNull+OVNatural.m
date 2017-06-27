//
//  NSNull+OVNatural.m
//  mima_ST
//
//  Created by NISSAY IT on 2017/6/6.
//  Copyright © 2017年 NISSAY IT. All rights reserved.
//

#import "NSNull+OVNatural.h"

@implementation NSNull (OVNatural)

- (void)forwardInvocation:(NSInvocation *)invocation
{
    
    if ([self respondsToSelector:[invocation selector]]) {
        
        [invocation invokeWithTarget:self];
    }
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *sig = [[NSNull class] instanceMethodSignatureForSelector:selector];
    
    if (sig == nil) {
        
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
        
    }
    
    return sig;
}


@end
