//
//  BaseModel.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BaseModel.h"
#import "NSObject+Property.h"
#import "NSString+Additions.h"
#import "NSArray+Additions.h"
#import <objc/runtime.h>
#ifdef DEBUG
static NSMutableDictionary *ivarDictionay = nil;
#endif

@implementation BaseModel

#ifdef DEBUG
- (NSString *)description
{
    Class cls = [self class];
    NSString *className = NSStringFromClass(cls);
    if (ivarDictionay == nil)
        ivarDictionay = [[NSMutableDictionary alloc] init];
    
    if ([ivarDictionay objectForKey:className] == nil)
    {
        NSMutableArray *ivarArray = [[NSMutableArray alloc] init];
        
        unsigned int count = 0;
        do{
            Ivar *ivars = class_copyIvarList(cls, &count);
            for (uint i = 0; i < count; i++)
            {
                NSString *ivar = [[NSString alloc] initWithUTF8String:ivar_getName(ivars[i])];
                [ivarArray addObject:ivar];
            }
            free(ivars);
        }
        while ((cls = class_getSuperclass(cls))!= [BaseModel class]);
        
        [ivarDictionay setObject:ivarArray forKey:className];
    }
    
    NSArray *ivarArray = [ivarDictionay objectForKey:className];
    NSMutableDictionary *ivarDict = [[NSMutableDictionary alloc] initWithCapacity:ivarArray.count];
    for (NSString *ivar in ivarArray)
    {
        id value = [self valueForKey:ivar];
        [ivarDict setValue:(value ? value : [NSNull null]) forKey:ivar];
    }
    
    NSString *_description = [ivarDict description];
    return _description ;
}
#endif

+ (id)instanceWithDict:(NSDictionary *)dict
{
    return [dict isKindOfClass:[NSDictionary class]] ? [[self alloc] initWithDict:dict] : nil;
}

#pragma mark -
#pragma mark ==== BaseModelProtocol ====
#pragma mark -
- (id)initWithDict:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if ((self = [self init]))
    {
        static NSString *setMethodString = @"set%@:";
        static Class stringClass = NULL;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            stringClass = [NSString class];
        });
        static SEL selector = NULL;
        
        NSEnumerator *enumerator = [dict keyEnumerator];
        id key;
        
        while ((key = [enumerator nextObject]))
        {
            if (![key isKindOfClass:stringClass]) continue;
            id obj = [dict objectForKey:key];
            if ([[NSNull null] isEqual:obj]) continue;
            selector = NSSelectorFromString([NSString stringWithFormat:setMethodString, [key capitalize]]);
            if (selector != NULL && [self respondsToSelector:selector])
                [self setValue:obj forKey:key];
            
        }
        selector = NULL;
        
    }
    return self;
}

- (id)initWithDict:(NSDictionary *)dict mapping:(NSDictionary *)mappingDict
{
    if (!mappingDict || ![mappingDict isKindOfClass:[NSDictionary class]]) return [self initWithDict:dict];
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) return nil;
    if ((self = [self init]))
    {
        NSEnumerator *enumerator = [dict keyEnumerator];
        id key;
        while ((key = [enumerator nextObject]))
        {
            if (![key isKindOfClass:[NSString class]]) continue;
            id newKey = [mappingDict objectForKey:key];
            if (newKey == nil || ![newKey isKindOfClass:[NSString class]]) continue;
            id obj = [dict objectForKey:key];
            if ([[NSNull null] isEqual:obj]) continue;
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [newKey capitalize]]);
            if (selector != NULL && [self respondsToSelector:selector])
                [self setValue:obj forKey:newKey];
        }
    }
    return self;
}

+ (NSMutableArray *)modelArrayWithDictArray:(NSArray *)dictArray
{
    if (![dictArray isKindOfClass:[NSArray class]] || dictArray.count == 0) return nil;
    
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:dictArray.count];
    for (NSDictionary *dictionary in dictArray)
    {
        if ([dictionary isKindOfClass:[NSDictionary class]])
        {
            id model = [[[self class] alloc] initWithDict:dictionary];
            [modelArray addObject:model];
        }
    }
    return modelArray;
}

- (NSMutableDictionary *)dictionaryValue
{
    Class baseModelClass = [BaseModel class];
    if ([self isMemberOfClass:baseModelClass])
        return nil;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    Class cls = [self class];
    do
    {
        unsigned int count = 0;
        
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        for (unsigned int i=0; i<count; i++)
        {
            NSString *prop = [[NSString alloc] initWithUTF8String:property_getName(properties[i])];
            id value = [self valueForKey:prop];
            if (!value)
            {
                continue;
            }
            //处理值为basemodel子类
            if ([value isKindOfClass:baseModelClass])
            {
                [dictionary setValue:[(BaseModel *)value dictionaryValue] forKey:[prop capitalize]];
            }
            //处理数组， 后续可以考虑处理字典
            else if ([value isKindOfClass:[NSArray class]])
            {
                NSArray *valueArray = (NSArray *)value;
                NSMutableArray *modelArray = [[NSMutableArray alloc] initWithCapacity:valueArray.count];
                for (BaseModel *model in valueArray)
                {
                    if ([model isKindOfClass:baseModelClass])
                        [modelArray safeAddObject:[model dictionaryValue]];
                    else
                        [modelArray addObject:model];
                }
                [dictionary setValue:modelArray forKey:[prop capitalize]];
            }
            else
                [dictionary setValue:value forKey:[prop capitalize]];
        }
        free(properties);
    }
    while ((cls = class_getSuperclass(cls))!= baseModelClass);
    
    return dictionary;
}

#pragma mark -
#pragma mark ==== NSKeyValueCodingProtocol ====
#pragma mark -

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@ is not in %@", key, NSStringFromClass([self class]));
}

- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"set nil value for %@ in %@", key, NSStringFromClass([self class]));
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (([key endsWith:@"date"] || [key endsWith:@"time"]) && [[self typeClassName:key] isEqualToString:@"NSDate"])
    {
        if ([value isKindOfClass:[NSString class]])
        {
            NSString *valueString = [value description];
#ifndef PAD_PADCocos2dMacro
            if (valueString.length == 19 && [valueString matches:@"^\\d{4}(-\\d{2}){2} \\d{2}(\\:\\d{2}){2}$"])
            {
                //pass "9999-12-31 23:59:59"
                if ([valueString startsWith:@"9999"]) return;
                [super setValue:[valueString convertToDateWithFormat:@"yyyy-MM-dd HH:mm:ss"]
                         forKey:key];
            }
#else
            if (valueString.length == 19)
            {
                if ([valueString hasPrefix:@"9999"])
                {
                    return;
                }
                
                if ([valueString convertToDateWithFormat:DefaultDateTimeFormatString])//能转换说明字符串是日期型
                {
                    [super setValue:[valueString convertToDateWithFormat:DefaultDateTimeFormatString]
                             forKey:key];
                }
            }
#endif
        }
        else
            [super setValue:value forKey:key];
        
    }
    else
        [super setValue:value forKey:key];
}

#pragma mark -
#pragma mark ==== NSCodingProtocol ====
#pragma mark -

//if your model is immutable - i.e. it isn't modifed at runtime, then
//you don't need to implement this stuff. you might want this for
//models where the user can modify the data and save it, or for models
//that are downloaded from a web service and need to be saved locally


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [self init]))
    {
        ////in the real implementation you would load propeties from the decoder object, e.g.
        //self.someProperty = [aDecoder decodeObjectForKey:@"someProperty"];
        [NSException raise:NSGenericException
                    format:@"Abstract -initWithCoder implementation - you need to override this in model %@",
         NSStringFromClass([self class])];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    ////in the real implementation you would write properties to the coder object, e.g.
    //[aCoder encodeObject:someProperty forKey:@"someProperty"];
    [NSException raise:NSGenericException
                format:@"Abstract -encodeWithCoder implementation - you need to override this in model %@",
     NSStringFromClass([self class])];
}

#pragma mark === instanceMethod
// 重写debugDescription
//- (NSString *)debugDescription {
//
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    
//    uint count;
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    
//    for (int i = 0; i<count; i++) {
//        objc_property_t property = properties[i];
//        NSString *name = @(property_getName(property));
//        id value = [self valueForKey:name]?:@"nil";
//        [dictionary setObject:value forKey:name];
//    }
//    
//    free(properties);
//    
//    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class],self,dictionary];
//}



@end
