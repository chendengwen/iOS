//
//  BaseCodingModel.m
//  FuncGroup
//
//  Created by gary on 2017/3/3.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BaseCodingModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation BaseCodingModel
{
    BOOL _finishInit;   // 读文件是否完成
}

+(void)load{
    Method method_origin = class_getInstanceMethod([self class], @selector(setValue:forKey:));
    Method method_new = class_getInstanceMethod([self class], @selector(G_setValue:forKey:));
    method_exchangeImplementations(method_origin, method_new);
    
    Method method_origin_1 = class_getInstanceMethod([self class], @selector(setValuesForKeysWithDictionary:));
    Method method_new_1 = class_getInstanceMethod([self class], @selector(G_setValuesForKeysWithDictionary:));
    method_exchangeImplementations(method_origin_1, method_new_1);
}

#pragma parm === Input
#pragma mark === 实际调用
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
}

-(BOOL)G_setValue:(id)value forKey:(NSString *)key{
    [self G_setValue:value forKey:key];
    
    if (_finishInit) {
        return [self archiveRootObjectToFile];
    }
    return YES;
}

- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
    [self G_setValuesForKeysWithDictionary:keyedValues];
    [self archiveRootObjectToFile];
}

- (BOOL)G_setValuesForKeysWithDictionary:(NSDictionary<NSString *, id> *)keyedValues{
    [super setValuesForKeysWithDictionary:keyedValues];
    return [self archiveRootObjectToFile];
}

-(BOOL)archiveRootObjectToFile{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:G_str(@"%@.data",NSStringFromClass([self class]))];
    return [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

#pragma parm === Output
- (nullable id)valueForKey:(NSString *)key{
    id value = [super valueForKey:key];
    if ([value isKindOfClass:[NSNull class]] || value == 0x0) {
        return nil;
    }
    return value;
}

+(BaseCodingModel *)valuesFromUnarchiveing{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:G_str(@"%@.data",NSStringFromClass([self class]))];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

#pragma mark === ClearData
+(BOOL)clearCodingDataFilePath:(NSString *)filePath{
    if (filePath) {
        return [NSKeyedArchiver archiveRootObject:@"" toFile:filePath];
    }else {
        NSString *defaultFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:G_str(@"%@.data",NSStringFromClass([self class]))];
        return [NSKeyedArchiver archiveRootObject:@"" toFile:defaultFilePath];
    }
}

#pragma parm === init
- (instancetype)init
{
    self = [super init];
    if (self) {
        _finishInit = YES;
    }
    return self;
}

#pragma parm === NSCoding
/**
 *  读文件
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i ++) {
            Ivar ivar = ivars[i];
            const char *key = ivar_getName(ivar);
            NSString *keyStr = [NSString stringWithUTF8String:key];
            [self setValue:[coder decodeObjectForKey:keyStr] forKey:keyStr];
        }
        _finishInit = YES;
        
        free(ivars);
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)coder{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        const char *key = ivar_getName(ivar);
        NSString *keyStr = [NSString stringWithUTF8String:key];
        [coder encodeObject:[self valueForKey:keyStr] forKey:keyStr];
    }
    free(ivars);
}


@end
