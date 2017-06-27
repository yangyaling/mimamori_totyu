//
//  NullSafe.m
//
//  Version 1.2.2
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>


#ifndef NULLSAFE_ENABLED

#define NULLSAFE_ENABLED 1


#endif


#pragma GCC diagnostic ignored "-Wgnu-conditional-omitted-operand"


@implementation NSNull (NullSafe)


#if NULLSAFE_ENABLED

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    @synchronized([self class])
    {
        //查找方法签名
        NSMethodSignature *signature = [super methodSignatureForSelector:selector];
        
        if (!signature)
        {
            //通过nsnull不支持，搜索其他类
            static NSMutableSet *classList = nil;
            static NSMutableDictionary *signatureCache = nil;
            if (signatureCache == nil)
            {
                classList = [[NSMutableSet alloc] init];
                signatureCache = [[NSMutableDictionary alloc] init];
                
                //获得类列表
                int numClasses = objc_getClassList(NULL, 0);
                Class *classes = (Class *)malloc(sizeof(Class) * (unsigned long)numClasses);
                numClasses = objc_getClassList(classes, numClasses);
                
                //添加到列表检查
                NSMutableSet *excluded = [NSMutableSet set];
                for (int i = 0; i < numClasses; i++)
                {
                    //确定类有一个父类
                    Class someClass = classes[i];
                    Class superclass = class_getSuperclass(someClass);
                    while (superclass)
                    {
                        if (superclass == [NSObject class])
                        {
                            [classList addObject:someClass];
                            break;
                        }
                        [excluded addObject:NSStringFromClass(superclass)];
                        superclass = class_getSuperclass(superclass);
                    }
                }

                //移除所有有子类的类
                for (Class someClass in excluded)
                {
                    [classList removeObject:someClass];
                }

                //免费类列表
                free(classes);
            }
            
            //检查执行缓存第一
            NSString *selectorString = NSStringFromSelector(selector);
            signature = signatureCache[selectorString];
            if (!signature)
            {
                //找到实现
                for (Class someClass in classList)
                {
                    if ([someClass instancesRespondToSelector:selector])
                    {
                        signature = [someClass instanceMethodSignatureForSelector:selector];
                        break;
                    }
                }
                
                //下次缓存
                signatureCache[selectorString] = signature ?: [NSNull null];
            }
            else if ([signature isKindOfClass:[NSNull class]])
            {
                signature = nil;
            }
        }
        return signature;
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    invocation.target = nil;
    [invocation invoke];
}

#endif

@end
