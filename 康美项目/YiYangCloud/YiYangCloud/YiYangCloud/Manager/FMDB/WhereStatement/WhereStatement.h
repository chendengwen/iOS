//
//  WhereStatement.h
//  FuncGroup
//
//  Created by gary on 2017/2/23.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConstants.h"

#define WS_key(x) [WhereStatement instanceWithKey:PropertyStr(x)]
#define WS_keyOper(x,y) [WhereStatement instanceWithKey:PropertyStr(x) operation:y]
#define WS_keyOperLink(x,y,z) [WhereStatement instanceWithKey:PropertyStr(x) operation:y relationShip:z]

@interface WhereStatement : NSObject

/*!
 @brief  sql语句where表达式中的key
 */
@property (nonatomic, copy) NSString *key;

/*!
 @brief  sql语句where表达式中的运算
 */
@property (nonatomic, assign) SqlOperationType operationType;

/*!
 @brief  sql语句where表达式中的连接关系
 */
@property (nonatomic, assign) SqlLinkRelationShipType linkType;

/*！
 @brief  返回默认为“=”运算，“and”连接的单个where表达式
 @prama  mkey：where语句的key
 @return 单个where表达语句对象
 */
+ (WhereStatement *)instanceWithKey:(NSString *)mkey;

/*！
 @brief  返回默认为“and”连接的单个where表达式
 @prama  mkey：where语句的key
 @prama  mType: 对应的运算
 @return 单个where表达语句对象
 */
+ (WhereStatement *)instanceWithKey:(NSString *)mkey operation:(SqlOperationType)mType;

/*！
 @brief  返回单个where表达式
 @prama  mkey：where语句的key
 @prama  mOperationType: 对应的运算
 @prama  mlinkType：对应的连接
 @return 单个where表达语句对象
 */
+ (WhereStatement *)instanceWithKey:(NSString *)mkey
                          operation:(SqlOperationType)mOperationType
                       relationShip:(SqlLinkRelationShipType)mlinkType;

///*!
// @brief  返回单个where表达式
// */
//- (NSString *)whereExpression:(NSObject *)object;

@end
