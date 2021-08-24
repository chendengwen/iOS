//
//  NSDictionary+Additions.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Additions.h"
#import <objc/runtime.h>
#import "Frame+Additions.h"

//获取指定dicitonary的指定key的对象并判断其类型
CF_INLINE id pdGetObjectInDictionaryWithKeyAndType(NSDictionary *dictionary, id aKey, Class aType);


CF_INLINE id pdGetObjectInDictionaryWithKeyAndType(NSDictionary *dictionary, id aKey, Class aType)
{
    if (dictionary == nil || aKey == nil || aType == NULL)
        return nil;
    id obj = [dictionary objectForKey:aKey];
    return [obj isKindOfClass:aType] ? obj : nil;
}


@implementation NSDictionary (Additions)

- (id)objectForKey:(id)aKey withType:(Class)aType
{
    return pdGetObjectInDictionaryWithKeyAndType(self, aKey, aType);
}

- (NSString *)stringForKey:(id)aKey
{
    return pdGetObjectInDictionaryWithKeyAndType(self, aKey, [NSString class]);
}

- (NSArray *)arrayForKey:(id)aKey
{
    return pdGetObjectInDictionaryWithKeyAndType(self, aKey, [NSArray class]);
}

- (NSDictionary *)dictionaryForKey:(id)aKey
{
    return pdGetObjectInDictionaryWithKeyAndType(self, aKey, [NSDictionary class]);
}

- (NSNumber *)numberForKey:(id)aKey
{
    return pdGetObjectInDictionaryWithKeyAndType(self, aKey, [NSNumber class]);
}

- (BOOL)boolForKey:(id)aKey
{
    if ([aKey respondsToSelector:@selector(boolValue)])
        return [aKey boolValue];
    return NO;
}

- (CGPoint)pointForKey:(NSString *)key
{
    CGPoint point = CGPointZero;
    NSDictionary *dictionary = [self valueForKey:key];
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) return point;
    BOOL success = CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)dictionary, &point);
    if (success) return point;
    return CGPointZero;
}

- (CGSize)sizeForKey:(NSString *)key
{
    CGSize size = CGSizeZero;
    NSDictionary *dictionary = [self valueForKey:key];
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) return size;
    BOOL success = CGSizeMakeWithDictionaryRepresentation((CFDictionaryRef)dictionary, &size);
    if (success) return size;
    return CGSizeZero;
}

- (CGRect)rectForKey:(NSString *)key
{
    CGRect rect = CGRectZero;
    NSDictionary *dictionary = [self valueForKey:key];
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) return rect;
    BOOL success = CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)dictionary, &rect);
    if (success) return rect;
    return CGRectZero;
}

- (BOOL)containsKey:(id)key
{
    return [[self allKeys] containsObject:key];
}

+ (id)safeDictionaryWithObjectsAndKeys:(id)firstObject, ...
{
    va_list valist;
    va_start(valist, firstObject);
    
    id object = firstObject;
    
    if (!object)
    {
        NSLog(@"Initialize a dictionary error : attempt to insert nil object from objects[0]");
        return nil;
    }
    
    //将value和key分别存入不同数组
    int i=0;
    NSMutableArray *objects = [NSMutableArray array];
    NSMutableArray *keys = [NSMutableArray array];
    while (object)
    {
        i%2 == 0 ? [objects addObject:object] : [keys addObject:object];
        i++;
        object = va_arg(valist, id);
    }
    
    va_end(valist);
    
    if (objects.count != keys.count) return nil;
    
    //判断key是否实现了NSCoping协议
    __block BOOL isAllKeyConformsNSCoping = YES;
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![[obj class] conformsToProtocol:@protocol(NSCopying)])
        {
            isAllKeyConformsNSCoping = NO;
            *stop = YES;
        }
    }];
    if (!isAllKeyConformsNSCoping)
    {
        NSLog(@"Checking keys error : one key did not comform NSCoping protocol.");
        return nil;
    }
    
    return [self dictionaryWithObjects:objects forKeys:keys];
}


+ (NSDictionary *)dictionaryWithObject:(id)object
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = NULL;
    
    properties = [NSDictionary getObjProperites:[object class] count:&count];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        Class classObject = NSClassFromString([key capitalizedString]);
        
        if (classObject) {
            id subObj = [self dictionaryWithObject:[object valueForKey:key]];
            [dict setObject:subObj forKey:key];
        }
        else
        {
            id value = [object valueForKey:key];
            if(value)
            {
                [dict setObject:value forKey:key];
            }
            else
            {
                [dict setObject:@"" forKey:key];
            }
        }
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

/**
 *  参数排序拼接
 *  @return 拼接后字符串
 */
- (NSString *)genSign
{
    // 排序
    NSArray *keys = [self allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[self objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    NSLog(@"--- Gen sign: %@", signString);
    return signString;
}



+ (objc_property_t *)getObjProperites:(Class)className count:(unsigned int*)count
{
    objc_property_t *selfProperties = class_copyPropertyList(className, count);
    objc_property_t *superProperties = NULL;
    objc_property_t *properties = NULL;
    
    Class superClass = class_getSuperclass(className);
    if (superClass != [NSObject class]) {
        unsigned int superPropertyCount;
        superProperties = [NSDictionary getObjProperites:superClass count:&superPropertyCount];
        
        properties = malloc((*count + superPropertyCount) * sizeof(objc_property_t));
        if (properties != NULL) {
            memcpy(properties, selfProperties, *count * sizeof(objc_property_t));
            memcpy(properties + *count, superProperties, superPropertyCount * sizeof(objc_property_t));
        }
        
        *count = *count + superPropertyCount;
        free(superProperties);
        free(selfProperties);
        
        return properties;
    }
    
    return selfProperties;
}


@end
