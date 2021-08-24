//
//  NSObject+Property.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *_getPropertyStr(char *str);

#define PropertyStr(aa) _getPropertyStr(#aa)

@interface NSObject (Property)

/*!
 @brief     获得对象的所有属性
 */
- (NSArray *)getPropertyList;
/*!
 @brief     获得对象的所有属性
 @prama     clazz 对应的实体类
 */
- (NSArray *)getPropertyList: (Class)clazz;
/*!
 @brief     获得对应属性名的属性类型
 @prama     propertyName 属性名
 */
- (NSString *)typeClassName:(NSString *)propertyName;

/*!
 @brief     修改属性值
 */
//- (void)setValue:(id)value forProperty:(id)property;

@end
