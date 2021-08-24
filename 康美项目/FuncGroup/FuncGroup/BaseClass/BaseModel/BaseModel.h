//
//  BaseModel.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 @protocol  BaseModel
 @brief     BaseModel实现的协议
 */
@protocol BaseModel <NSObject>
/*!
 @brief     使用字典初始化一个实例
 @param     dict 包含初始化数据的字典
 @return    id BaseModel实例
 */
+ (id)instanceWithDict:(NSDictionary *)dict;
/*!
 @brief     使用字典初始化一个实例
 @param     dict 包含初始化数据的字典
 @return    id BaseModel实例
 */
- (id)initWithDict:(NSDictionary *)dict;
//- (id)initWithArray:(NSArray *)array;

/*!
 @brief     使用字典按照对应的映射字典初始化一个实例
 @param     dict 包含初始化数据的字典
 @param     mappingDict 字典数据key与实体属性之间的隐射字典
 @return    BaseModel实例
 */
- (id)initWithDict:(NSDictionary *)dict mapping:(NSDictionary *)mappingDict;

/*!
 @brief     传入指定的dictionary数组， 生成对应实体的数组
 @param     dictArray dictionary数组
 @return    视图数组
 */
+ (NSMutableArray *)modelArrayWithDictArray:(NSArray *)dictArray;
/*!
 @brief     将实体转为字典类型
 */
- (NSMutableDictionary *)dictionaryValue;

@end


/*!
 @class BaseModel
 @brief 所有实体类的基类
 */
@interface BaseModel : NSObject<BaseModel>



@end
