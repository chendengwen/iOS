//
//  BaseDBController.h
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "BaseDBHelper.h"
#import "NSObject+Property.h"


/*!
 @class BaseDBController
 @brief 基础数据库控制器
 */
@interface BaseDBController : NSObject

/*!
 @brief     基础数据db queue
 */
@property (nonatomic, readonly, strong) FMDatabaseQueue *dbQueue;

/*!
 @brief     自动化数据库操作类
 */
@property (nonatomic, strong) BaseDBHelper *dbHelper;

/*!
 @brief     单例
 */
+ (instancetype)dbController;

@end
