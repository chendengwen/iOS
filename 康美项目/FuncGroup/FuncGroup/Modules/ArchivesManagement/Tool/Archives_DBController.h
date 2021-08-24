//
//  Archives_DBController.h
//  FuncGroup
//
//  Created by zhong on 2017/3/1.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BaseDBController.h"
#import "ArchivesModel.h"

@interface Archives_DBController : BaseDBController
/*!
 @brief     获取分页数据
 @param     pageIndex 分页索引
 @return	返回NSArray
 */
- (NSArray *)getArchivesRecordPageIndex:(NSInteger)pageIndex;

/*!
 @brief     插入一条数据
 @param     model 数据模型
 */
-(void)insertArchivesRecord:(ArchivesModel *)model;

/*
 @brief 获取所有数据
 */
- (NSArray *)getAllRecord;
/*
 @brief 插入一条数据
 */
-(void)insertRecord:(ArchivesModel *)model;
/*
 @brief 更改一条数据
 */
-(void)updateRecord:(ArchivesModel *)model;
/*
 @brief 删除一条数据
 */
-(void)deleteRecord:(ArchivesModel *)model;
/*
 @brief 查询一条数据
 */
-(NSArray *)queryRecord:(ArchivesModel *)model;
@end
