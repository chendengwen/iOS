//
//  NSObject+Property.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>
#import "NSString+Additions.h"

NSString *_getPropertyStr(char *str)
{
    if (str == NULL) return @"";
    NSString *resultString = @(str);
    if ([resultString rangeOfString:@"."].location == NSNotFound)
        return resultString;
    return [resultString componentsSeparatedByString:@"."][1];
}


@implementation NSObject (Property)


- (NSArray *)getPropertyList
{
    return [self getPropertyList:[self class]];
}

- (NSArray *)getPropertyList: (Class)clazz
{
    NSMutableArray *propertyList = [[NSMutableArray alloc] init];
    while (clazz)
    {
        if ([NSStringFromClass(clazz) isEqualToString:@"BaseModel"])
        {
            return propertyList;
        }
        
        u_int count;
        objc_property_t *properties  = class_copyPropertyList(clazz, &count);
        NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
        
        for (int i = 0; i < count ; i++)
        {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject: [NSString  stringWithUTF8String: propertyName]];
        }
        
        free(properties);
        clazz = [clazz superclass];
        [propertyList addObjectsFromArray:propertyArray];
    }
    return propertyList;
}

- (NSString *)typeClassName:(NSString *)propertyName
{
    NSString *tempPropertyName;
    // 移除开头的下划线
    if ([propertyName hasPrefix:@"_"]) {
        tempPropertyName = [propertyName substringFromIndex:1];
    } else tempPropertyName = propertyName;
    
    objc_property_t property = class_getProperty([self class], [tempPropertyName UTF8String]);
    const char * type = property_getAttributes(property);

    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    const char * rawPropertyType = [propertyType UTF8String];
    
    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1)
    {
        return [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
    }
    if (strcmp(rawPropertyType, @encode(BOOL)) == 0)
    {
        return @"BOOL";
    }
    if (strcmp(rawPropertyType, @encode(int)) == 0)
    {
        return @"int";
    }
    if (strcmp(rawPropertyType, @encode(float)) == 0)
    {
        return @"float";
    }
    if (strcmp(rawPropertyType, @encode(double)) == 0)
    {
        return @"double";
    }
    if (strcmp(rawPropertyType, @encode(id)))
    {
        return @"id";
    }
    if (strcmp(rawPropertyType, @encode(long)) == 0)
    {
        return @"long";
    }
    if (strcmp(rawPropertyType, @encode(long long)) == 0)
    {
        return @"long long";
    }
    if (strcmp(rawPropertyType, @encode(unsigned long long)) == 0)
    {
        return @"unsigned long long";
    }
    return @"";
}


@end
