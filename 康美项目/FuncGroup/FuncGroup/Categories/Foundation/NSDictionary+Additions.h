//
//  NSDictionary+Additions.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

@interface NSDictionary (Additions)

//按指定类型和key取出对象，为空或者类型不对时，返回nil
- (id)objectForKey:(id)aKey withType:(Class)aType;
- (NSString *)stringForKey:(id)aKey;
- (NSArray *)arrayForKey:(id)aKey;
- (NSDictionary *)dictionaryForKey:(id)aKey;
- (NSNumber *)numberForKey:(id)aKey;
//指定key对应的obj如果实现了boolValue方法，则调用并返回结果， 否则返回NO; 注意这里的实现。
- (BOOL)boolForKey:(id)aKey;


- (CGPoint)pointForKey:(NSString *)key;
- (CGSize)sizeForKey:(NSString *)key;
- (CGRect)rectForKey:(NSString *)key;

//是否包含指定key
- (BOOL)containsKey:(id)key;
+ (id)safeDictionaryWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;


/**
 *  @brief  返回一个对象的nsdictionary
 *  @param object 对象
 *  @return nsdictionary对象
 */
+ (NSDictionary *)dictionaryWithObject:(id)object;

/**
 *  @brief 参数排序拼接
 *  @return 拼接后字符串
 */
- (NSString *)genSign;

@end


@interface NSMutableDictionary (UtilsExtras)
//安全设置指定key的对象值
- (void)safeSetObject:(id)anObject forKey:(id)aKey;

- (void)setPoint:(CGPoint)value forKey:(NSString *)key;
- (void)setSize:(CGSize)value forKey:(NSString *)key;
- (void)setRect:(CGRect)value forKey:(NSString *)key;

@end
