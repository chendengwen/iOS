//
//  Constants.h
//  DBDemo
//
//  Created by paidui-mini on 13-10-17.
//  Copyright (c) 2013年 paidui-mini. All rights reserved.
//

#ifndef DBDemo_Constants_h
#define DBDemo_Constants_h

/*!
 @brief sql比较类型
 */
typedef NS_ENUM(NSUInteger, SqlOperationType)
{
    /*!
     @brief  等于
    */
    SqlOperationEqual = 0,
    /*!
     @brief  不等于
     */
    SqlOperationInEqual,
    /*!
     @brief  大于
     */
    SqlOperationGreater,
    /*!
     @brief  小于
     */
    SqlOperationLess,
    /*!
     @brief  大于等于
     */
    SqlOperationGreaterAndEqual,
    /*!
     @brief  小于等于
     */
    SqlOperationLessAndEqual,
    /*!
     @brief  between
     */
    SqlOperationBetween,
    /*!
     @brief  like
     */
    SqlOperationLike
};

typedef NS_ENUM(NSUInteger, SqlLinkRelationShipType)
{
    /*!
     @brief  and连接
     */
    SqlLinkRelationshipAnd = 100,
    /*!
     @brief  or连接
     */
    SqlLinkRelationShipOr
};

typedef NS_ENUM(NSUInteger, SelectOrderByType)
{
    /*!
     @brief  降序
     */
    SelectOrderByDesc,
    /*!
     @brief  升序
     */
    SelectOrderByAsc                    
};

#endif
