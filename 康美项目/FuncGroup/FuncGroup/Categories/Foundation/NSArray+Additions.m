//
//  NSArray+Additions.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (id)firstObject {
    return self.count > 0 ? [self objectAtIndex:0] : nil;
}

- (id)safeGetObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self objectAtIndex:index];
}



- (NSArray *)subarrayFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex > toIndex) return nil;
    NSUInteger count = self.count;
    if (fromIndex >= count) return nil;
    if (toIndex >= count)
        toIndex = count - 1;
    return [self subarrayWithRange:NSMakeRange(fromIndex, toIndex - fromIndex + 1)];
}

- (NSArray *)concatWithObjects:(id)obj, ... NS_REQUIRES_NIL_TERMINATION
{
    if (!obj) return self;
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:self];
    
    va_list valist;
    va_start(valist, obj);
    
    id paramObj = obj;
    do
    {
        if ([paramObj isKindOfClass:[NSArray class]])
            [resultArray addObjectsFromArray:paramObj];
        else
            [resultArray addObject:paramObj];
    }
    while ((paramObj = va_arg(valist, id)) != nil);
    
    va_end(valist);
    
    return resultArray;
}

- (NSArray *)concatWithArray:(NSArray *)concatArray
{
    if (!concatArray) return self;
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:self];
    for (id obj in concatArray)
    {
        if ([obj isKindOfClass:[NSArray class]])
            [resultArray addObjectsFromArray:obj];
        else
            [resultArray addObject:obj];
    }
    return resultArray;
}

#if NS_BLOCKS_AVAILABLE

- (id)find:(BOOL (^)(id obj))block
{
    if (!block) return nil;
    //    __block id result = nil;
    //    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //        if (block(obj))
    //        {
    //            result = obj;
    //            *stop = YES;
    //        }
    //    }];
    //    return result;
    for (id item in self)
        if (block(item))
            return item;
    return nil;
}

- (void)each:(void (^)(id obj))block
{
    if (!block) return;
    //    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //        block(obj);
    //    }];
    for (id item in self)
        block(item);
}

- (NSArray *)map:(id (^)(id obj, NSUInteger idx))block
{
    if (!block) return nil;
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [resultArray safeAddObject:block(obj, idx)];
    }];
    return resultArray;
}

- (NSArray *)filter:(BOOL (^)(id obj))block
{
    if (!block) return nil;
    NSMutableArray *resultArray = [NSMutableArray array];
    //    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //        if (block(obj))
    //            [resultArray addObject:obj];
    //    }];
    for (id item in self)
        if (block(item))
            [resultArray addObject:item];
    return resultArray;
}

- (NSString *)componentsJoinedByString:(NSString *)separator withBlock:(NSString *(^)(id obj))block
{
    if (!block || self.count == 0) return nil;
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:self.count];
    //    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //        NSString *resultString = block(obj);
    //        if ([resultString isKindOfClass:[NSString class]])
    //            [resultArray addObject:resultString];
    //    }];
    Class stringClass = [NSString class];
    for (id item in self)
    {
        NSString *resultString = block(item);
        if ([resultString isKindOfClass:stringClass])
            [resultArray addObject:resultString];
    }
    return [resultArray componentsJoinedByString:separator];
}


/*!
 @brief     ascii码排序
 @return    排序后拼接
 */
- (NSString *)sortByASCII{
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];//yes升序排列，no,降序排列
    NSArray *resultArr = [self sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
    
    NSMutableString *mutableString = [NSMutableString string];
    if (self.count > 0) {
        for (int i = 0; i < resultArr.count; i ++) {
            [mutableString appendString:[resultArr safeGetObjectAtIndex:i]];
        }
    }
    return mutableString;
}

#endif

@end


@implementation NSMutableArray (PDUtilsExtras)


- (void)safelyInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject && index <= self.count)
        [self insertObject:anObject atIndex:index];
}

- (id)pop
{
    if (self.count)
    {
        //we need retain the object
        id obj = [self objectAtIndex:self.count - 1];
        [self removeLastObject];
        return obj;
    }
    
    return nil;
}

- (id)shift
{
    if (self.count)
    {
        id obj = [self objectAtIndex:0];
        [self removeObjectAtIndex:0];
        return obj;
    }
    
    return nil;
}

- (void)safeAddObject:(id)anObject
{
    if (anObject)
        [self addObject:anObject];
}

- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex)
        return;
    NSUInteger count = self.count;
    if (fromIndex >= count || toIndex >= count)
        return;
    
    id obj = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    [self insertObject:obj atIndex:toIndex];
}

@end