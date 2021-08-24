//
//  DBHealthRecordController.h
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BaseDBController.h"
#import "HealthRecordPublic.h"

@class HealthBaseModel;

@interface DBHealthRecordController : BaseDBController

/*!
 @brief 区分不同表 !!!! 使用 DBHealthRecordController 前必须赋值
 */
@property (assign,nonatomic) HealthRecordType type;

/*!
 @brief 获取所有数据
 @return NSArray<HealthBaseModel *> 结果数据列表
 */
- (NSArray<HealthBaseModel *> *)getAllRecord;

/*!
 @brief 根据uid获取所有数据
 @return NSArray<HealthBaseModel *> 结果数据列表
 */
-(NSArray<HealthBaseModel *> *)getAllRecordByUID;

/*!
 @brief 根据索引获取数据
 @prama pageIndex 分页索引，默认为0
 @return NSArray<HealthBaseModel *> 结果数据列表
 */
- (NSArray<HealthBaseModel *> *)getRecordPageIndex:(NSInteger)pageIndex;

/*!
 @brief 根据索引获取数据
 @prama pageIndex 分页索引，默认为0
 @prama size 分页尺寸，默认为10
 @return NSArray<HealthBaseModel *> 结果数据列表
 */
- (NSArray<HealthBaseModel *> *)getRecordPageIndex:(NSInteger)pageIndex pageSize:(int)size;


/*!
 @brief 插入一条数据
 */
-(BOOL)insertRecord:(HealthBaseModel *)model;

@end
