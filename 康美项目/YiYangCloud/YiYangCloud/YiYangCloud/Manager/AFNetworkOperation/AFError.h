//
//  AFError.h
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

CF_EXPORT NSString *const kAFErrorDomain;

//错误类型
typedef NS_ENUM(NSUInteger, AFErrorType)
{
    AFUnknownErrorType = 0,
    AFConnectionFailureErrorType = 1,
    AFRequestTimedOutErrorType = 2,
    AFAuthenticationErrorType = 3,
    AFRequestCancelledErrorType = 4,
    AFUnableToCreateRequestErrorType = 5,
    AFInternalErrorWhileBuildingRequestType  = 6,
    AFInternalErrorWhileApplyingCredentialsType  = 7,
    AFFileManagementError = 8,
    AFTooMuchRedirectionErrorType = 9,
    AFUnhandledExceptionError = 10,
    AFCompressionError = 11,
    
    AFUndefinedError = 100,                    //未知错误
    AFNetworkUnreachableError,
    AFLocationDisabledError,
    AFLocationFailedError,
    
    AFParseJSONError,                          //JSON解析错误
    AFReturnDataError,                         //获取服务器数据失败
    AFLoginTimeoutError,                       //未登录或者登录超时
    AFDBOperationError,                        //数据库操作错误
    AFNeedConfirmError,                        //需要进一步确认
    
    AFStatusDuplicatePostError ,               //重复提交
    
    AFRequestErrorParamInsufficiency = 40001,  // 参数不全
    AFRequestErrorParamFormatError = 40002,    // 参数格式不对
    AFRequestErrorVerifyFailed = 40003,        // 验证失败
    AFRequestErrorResoureInexistence = 40005,  // 资源不存在
    AFRequestErrorModuleInvalid = 40006,       // 模块不允许访问
    
    AFRequestErrorUploadFailed = 40201,        // 提交失败
    
    AFRequestErrorDataInsertError = 50001,     // 数据插入错误
    AFRequestErrorDataUpdataError = 50002,     // 数据更新错误
    AFRequestErrorDataDeleteResoureError = 50003,  // 数据删除错误
    AFRequestErrorDataOperationError = 50004,  // 数据操作错误
    
    AFRequestErrorUserInexistence = 60001,  // 用户不存在
    AFRequestErrorSendNoteFailed = 60002,  // 验证短信发送失败
    AFRequestErrorVerifyCodeError = 60003,  // 短信验证码错误
    AFRequestErrorVerifyCodeTimeOut = 60004,  // 短信验证码超时（180秒）
    AFRequestErrorNotSendVerifyCode = 60005,  // 尚未发送验证码
    AFRequestErrorSendVerifyCodeTwiceInMinute = 60006,  // 60秒内不能重复发送验证码
    AFRequestErrorPasswordMismatching = 60007,  // 两次输入的密码不一致
    AFRequestErrorPasswordMistaken = 60008,  // 密码错误
    AFRequestErrorPhoneNumNotRegister = 60009,  // 该手机号尚未注册
    AFRequestErrorPhoneNumHadRegister = 60010,  // 该手机号已经注册
    AFRequestErrorPasswordLessThan6Letters = 60021,  // 密码长度不能少于6位
    AFRequestErrorPasswordLongerThan20Letters = 60022,  // 密码长度不能大于20位
    
};

/*!
 @interface AFError
 @brief 用于封装处理/传递程序中各种错误
 */
@interface AFError : NSError

/*
 * 提示（非错误信息）
 */
@property (nonatomic,copy) NSString *subMsg;

/*!
 @brief     返回指定错误类型对应的错误信息
 @param     errorType 错误类型
 @return    错误类型对应的错误信息
 */
+ (NSString *)errorMessageForErrorType:(AFErrorType)errorType;

/*!
 @brief     根据给定错误类型和信息创建AFError实例
 @param     errorType 错误类型
 @param     errorMessage 错误描述信息
 @return    AFError实例
 */
+ (id)errorWithCode:(NSUInteger)errorType errorMessage:(NSString *)errorMessage;

/*!
 @brief     根据给定错误类型和信息创建PDError实例
 @param     errorType 错误类型
 @param     errorMessage 错误描述信息
 @return    PDError实例
 */
- (id)initWithCode:(NSUInteger)errorType errorMessage:(NSString *)errorMessage  subMessage:(NSString *)subMsg;

/*!
 @brief     根据 NSError 的实例生成 AFError
 @param     error NSError 的实例
 @return    AFError实例
 */
+ (id)errorWithError:(NSError *)error;
/*!
 @brief     根据 NSError 的实例生成 AFError
 @param     error NSError 的实例
 @return    AFError实例
 */
- (id)initWithError:(NSError *)error;

@end
