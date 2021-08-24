//
//  ErrorMessage.c
//  FuncGroup
//
//  Created by gary on 2017/3/20.
//  Copyright © 2017年 gary. All rights reserved.
//


#include "ErrorMessage.h"

char * ErrorMessageWithCode(int code){
    char *message;
    
    switch(code){
        case 1011:
            // 注册验证码发送失败
            message = "账号已通过注册";
            break;
        case 1021:
            // 重新注册验证码发送失败
            message = "账号已通过注册";
            break;
        case 1031:
            // 注册验证码失效
            message = "无效的验证码或验证码超时";
            break;
        case 1041:
            // 登入失败
            message = "登入账号或密码不相符";
            break;
        case 1051:
            // 重置认证码发送失败
            message = "该账号不存在";
            break;
        case 1052:
            // 重置认证码发送失败
            message = "该账号未启用，或是被冻结";
            break;
        case 1061:
            // 重置密码失败
            message = "无效的验证码或验证码超时";
            break;
        case 1071:
            // 修改密码错误
            message = "原始密码错误";
            break;
        default:
            message = "未知错误";
            break;
    }
    return message;
}
