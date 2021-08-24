//
//  HealthBaseModel.h
//  FuncGroup
//
//  Created by gary on 2017/3/1.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BaseModel.h"
#import "HealthModelProtocol.h"

/*!
 @class HealthBaseModel
 @brief 健康数据模型的基类
*/
@interface HealthBaseModel : BaseModel<HealthModelProtocol>

/*!
 @brief 用户id
 */
@property (nonatomic,assign) NSUInteger uid;

/*!
 @brief 设备类型,初始化时做设置
 */
@property (nonatomic,assign) NSUInteger type;


/*!
 @brief sql语句：获取模型对应表的全部记录
 */
//+ (NSString *)getAllDBRecord;

/*!
 @brief sql语句：获取模型对应表的全部记录
 @param whether 是否根据uid来查询
 */
+ (NSString *)getAllDBRecordByUID:(BOOL)whether;

/*!
 @brief sql语句：获取模型对应表的分页数据（语句中包含偏移）
 */
//+ (NSString *)getDBRecordAtPage;

/*!
 @brief sql语句：获取模型对应表的分页数据（语句中包含偏移）
 @param whether 是否根据uid来查询
 */
+ (NSString *)getDBRecordAtPageByUID:(BOOL)whether;

/*!
 @brief 获取对象自身所有属性,只获取当前类，不向父类查询
 @return 查询到的所有属性
 */
-(NSArray *)objectPropeties;

/*!
 @brief 获取对象自身所有属性
 @prama superClasses 向上查询的层级
 @return 查询到的所有属性
 */
-(NSArray *)objectPropeties:(int)superClasses;


@end
