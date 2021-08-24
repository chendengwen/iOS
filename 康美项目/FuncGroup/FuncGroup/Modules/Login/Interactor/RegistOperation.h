//
//  RegistOperation.h
//  FuncGroup
//
//  Created by gary on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistOperProtocol.h"

//extern NSString *const RegistError_NoPhoneNum;
//extern NSString *const RegistError_NoPassword;
//extern NSString *const RegistError_UnValidPassword;
//extern NSString *const RegistError_NotEquelPassword;
//extern NSString *const RegistError_NoCardID;
//extern NSString *const RegistError_NoVerifyNum;

@interface RegistOperation : NSObject

@property (nonatomic,weak) NSObject<RegistOperProtocol> *handler;

/*
 * 注册操作
 */
-(void)registOperate:(NSString *)phoneNum password:(NSString *)psd rePsd:(NSString *)rePsd verifyNum:(NSString *)verifyNum;

/*
 * 获取验证码
 */
-(void)getRegistVetifyCode:(NSString *)phoneNum;


@end
