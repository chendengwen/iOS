//
//  ArchivesModel.h
//  FuncGroup
//
//  Created by zhong on 2017/2/28.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDBController.h"
#import "ArchivesModel.h"

@interface DBUserArchivesController :BaseDBController

/*
@brief 获取所有数据
*/
- (NSArray *)getAllRecord;

/*
@brief 获取当前用户数据模型
*/
- (ArchivesModel *)getCurrentUserArchive;

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
-(BOOL)insertArchivesRecord:(ArchivesModel *)model;


/*
 @brief 更改一条数据
 */
-(BOOL)updateRecord:(ArchivesModel *)model;

-(BOOL)deleteRecord:(ArchivesModel *)model;

/*
 @brief 查询一条数据
 */
-(NSArray *)queryRecord:(ArchivesModel *)model;


@end
