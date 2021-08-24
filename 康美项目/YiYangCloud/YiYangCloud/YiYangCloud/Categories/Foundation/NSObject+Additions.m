//
//  NSObject+Additions.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "NSObject+Additions.h"

#import <objc/runtime.h>

#if NS_BLOCKS_AVAILABLE
#import <dispatch/dispatch.h>
#endif

@implementation NSObject (Additions)

- (NSDictionary *)getAllPropertiesAndVaules
{
    NSMutableDictionary *propertyDictionary = [NSMutableDictionary dictionary];
    unsigned int count,i;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (i=0; i<count; i++)
    {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        NSString *propertyNameString = [NSString stringWithUTF8String:propertyName];
        id propertyValue = [self valueForKey:propertyNameString];
        if (propertyValue)
        {
            [propertyDictionary setObject:propertyValue forKey:propertyNameString];
        }
    }
    return propertyDictionary;
}

- (void *)performSelector:(SEL)selector withValue:(void *)value
{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    [invocation setArgument:value atIndex:2];
    
    [invocation invoke];
    
    NSUInteger length = [[invocation methodSignature] methodReturnLength];
    
    // If method is non-void:
    if (length > 0) {
        void *buffer = (void *)malloc(length);
        [invocation getReturnValue:buffer];
        return buffer;
    }
    
    // If method is void:
    return NULL;
}

- (void)performSelector:(SEL)selector afterDelay:(NSTimeInterval)delay
{
    [self performSelector:selector withObject:nil afterDelay: delay];
}

#if NS_BLOCKS_AVAILABLE

- (void)performBlock:(Block_Void)block afterDelay:(NSTimeInterval)delay
{
    if (!block) return;
    
    __block BOOL isCancelled = NO;
    //define a wrapped block
    void (^wrappedBlock)(BOOL) = ^(BOOL isCancel)
    {
        if (isCancel)
        {
            isCancelled = YES;
            return;
        }
        if (!isCancelled) block();
    };
    
    wrappedBlock = [wrappedBlock copy];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        wrappedBlock(NO);
    });
}

#endif



@end
