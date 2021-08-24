//
//  ExceptionCatch.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "ExceptionCatch.h"

#import "DebuggHandler.h"

#define NSNullObjects @[@"",@0,@{},@[]]

@implementation NSNull (PDExceptionCatch)

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature)
    {
        GASSERT(NO);
        GErrorLog(DebugFormatStr(@"返回数据有问题，有NSNull未处理，执行方法:%@", NSStringFromSelector(selector)));
        for (NSObject *object in NSNullObjects) {
            signature = [object methodSignatureForSelector:selector];
            if (signature)
            {
                break;
            }
        }
        
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    
    for (NSObject *object in NSNullObjects)
    {
        if ([object respondsToSelector:aSelector]) {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    
    [self doesNotRecognizeSelector:aSelector];
}

@end


/*!
 @brief catch length method for nsarray/nsdictionary
 */
FOUNDATION_STATIC_INLINE NSUInteger lengthForClass(id obj)
{
    GErrorLog(DebugFormatStr(@"出现字符串方法调用，数据:%@", obj));
    return 0;
}

@implementation NSDictionary (PDExceptionCatch)

- (NSUInteger)length
{
    GASSERT(NO);
    return lengthForClass(self);
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"字典调用dic[0]形式，索引:%lu, 数据:%@", (unsigned long)idx, self));
    return nil;
}

- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"字典调用dic[0]=x形式，索引:%lu, 数据:%@", (unsigned long)index, self));
}

- (id)objectAtIndex:(NSUInteger)index
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"字典调用数组方法objectAtIndex:%ld， 数据:%@", (unsigned long)index, self));
    return nil;
}

- (void)addObject:(id)anObject
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"字典调用数组方法addObject:%@， 数据:%@", anObject, self));
}

@end


@implementation NSArray (PDExceptionCatch)

- (NSUInteger)length
{
    GASSERT(NO);
    return lengthForClass(self);
}

- (id)objectForKeyedSubscript:(id)key
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"数组调用dic[@\"x\"]形式，key:%@, 数据:%@", key, self));
    return nil;
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)aKey
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"数组调用dic[@\"x\"]=x形式，key:%@, object:%@, 数据:%@", aKey, object, self));
}

- (id)objectForKey:(id)aKey
{
    GASSERT(NO);
GErrorLog(DebugFormatStr(@"数组发送objectForKey消息，key:%@, 数据:%@", aKey, self));
    return nil;
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"数组发送setObject:forKey:消息，key:%@, object:%@, 数据:%@", aKey, anObject, self));
}

@end

@implementation NSString (PDExceptionCatch)

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"字符串调用dic[0]形式，索引:%lu, 数据:%@", (unsigned long)idx, self));
    return nil;
}

- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"字符串调用dic[0]=x形式，索引:%lu, 数据:%@", (unsigned long)index, self));
}

- (id)objectAtIndex:(NSUInteger)index
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"字符串调用数组方法objectAtIndex:%ld， 数据:%@", (unsigned long)index, self));
    return nil;
}

- (void)addObject:(id)anObject
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"字符串调用数组方法addObject:%@， 数据:%@", anObject, self));
}

- (id)objectForKeyedSubscript:(id)key
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"字符串调用dic[@\"x\"]形式，key:%@, 数据:%@", key, self));
    return nil;
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)aKey
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"字符串调用dic[@\"x\"]=x形式，key:%@, object:%@, 数据:%@", aKey, object, self));
}

- (id)objectForKey:(id)aKey
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"字符串发送objectForKey消息，key:%@, 数据:%@", aKey, self));
    return nil;
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
    GASSERT(NO);
    GErrorLog(DebugFormatStr(@"字符串发送setObject:forKey:消息，key:%@, object:%@, 数据:%@", aKey, anObject, self));
}

@end
