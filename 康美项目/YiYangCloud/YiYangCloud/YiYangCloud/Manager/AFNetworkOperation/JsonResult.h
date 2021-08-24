//
//  JsonResult.h
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

typedef NS_ENUM(NSInteger, NetworkRequestStatus)
{
    NetworkRequestStatusError           = 0,  // 服务器返回错误
    NetworkRequestStatusSuccess         = 1,  // 成功
    NetworkRequestStatusUnAuthorized    = 2,  // 未授权
    NetworkRequestStatusLoginTimeOut    = 3  // 未登陆或登录超时
};

@interface JsonResult : BaseModel

/*!
 @brief     errorCode 0=正常, 1=错误
 */
@property (nonatomic, assign) NSInteger errorCode;

/*!
 @brief     resMsg
 */
@property (nonatomic, copy) NSString *msg;

///*!
// @brief     success 成功标示
// */
//@property (nonatomic, assign) int success;

/*!
 @brief     params  非标准格式数据
 */
@property (nonatomic, strong) NSDictionary *content;

@end
