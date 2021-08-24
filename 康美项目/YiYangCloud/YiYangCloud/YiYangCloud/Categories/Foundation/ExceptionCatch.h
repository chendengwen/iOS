//
//  ExceptionCatch.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief 用于处理json解析后数据元素异常为nsnull之后方法调用crash的情况
 */
@interface NSNull (PDExceptionCatch)

@end


/*!
 @brief 用于catch部分未知异常， 如长度length, dic[0]等使用
 */
@interface NSDictionary (PDExceptionCatch)

/*!
 @brief 用于catch在NSDictionary中调用字符串类型的长度方法，记录日志后返回0
 */
- (NSUInteger)length __unavailable;
/*!
 @brief 该方法为数组的实现，用于catch在字典上的非法调用，多为数据格式不正确
 */
- (id)objectAtIndexedSubscript:(NSUInteger)idx __unavailable;
/*!
 @brief 该方法为数组的实现，用于catch在字典上的非法调用，多为数据格式不正确
 */
- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index __unavailable;
/*!
 @brief     该方法为数组的实现，用于catch在字典上的非法调用，多为数据格式不正确
 */
- (id)objectAtIndex:(NSUInteger)index __unavailable;
/*!
 @brief     该方法为数组的实现，用于catch在字典上的非法调用，多为数据格式不正确
 */
- (void)addObject:(id)anObject __unavailable;
@end

/*!
 @brief 用于catch部分未知异常， 如长度length, dic[0]等
 */
@interface NSArray (PDExceptionCatch)

/*!
 @brief 用于catch在NSArray中调用字符串类型的长度方法，记录日志后返回0
 */
- (NSUInteger)length __unavailable;
/*!
 @brief 该方法为字典的实现，用于catch在数组上的非法调用，多为数据格式不正确
 */
- (id)objectForKeyedSubscript:(id)key __unavailable;
/*!
 @brief 该方法为字典的实现，用于catch在数组上的非法调用，多为数据格式不正确
 */
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)aKey __unavailable;
/*!
 @brief     该方法为字典的实现，用于catch在数组上的非法调用，多为数据格式不正确
 */
- (id)objectForKey:(id)aKey __unavailable;
/*!
 @brief     该方法为字典的实现，用于catch在数组上的非法调用，多为数据格式不正确
 */
- (void)setObject:(id)anObject forKey:(id)aKey __unavailable;

@end

/*!
 @brief <#abstract#>
 */
@interface NSString (PDExceptionCatch)
/*!
 @brief 该方法为数组的实现，用于catch在字符串上的非法调用，多为数据格式不正确
 */
- (id)objectAtIndexedSubscript:(NSUInteger)idx __unavailable;
/*!
 @brief 该方法为数组的实现，用于catch在字符串上的非法调用，多为数据格式不正确
 */
- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index __unavailable;
/*!
 @brief     该方法为数组的实现，用于catch在字符串上的非法调用，多为数据格式不正确
 */
- (id)objectAtIndex:(NSUInteger)index __unavailable;
/*!
 @brief     该方法为数组的实现，用于catch在字符串上的非法调用，多为数据格式不正确
 */
- (void)addObject:(id)anObject __unavailable;
/*!
 @brief 该方法为字典的实现，用于catch在字符串上的非法调用，多为数据格式不正确
 */
- (id)objectForKeyedSubscript:(id)key __unavailable;
/*!
 @brief 该方法为字典的实现，用于catch在字符串上的非法调用，多为数据格式不正确
 */
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)aKey __unavailable;
/*!
 @brief     该方法为字典的实现，用于catch在字符串上的非法调用，多为数据格式不正确
 */
- (id)objectForKey:(id)aKey __unavailable;
/*!
 @brief     该方法为字典的实现，用于catch在字符串上的非法调用，多为数据格式不正确
 */
- (void)setObject:(id)anObject forKey:(id)aKey __unavailable;
@end



