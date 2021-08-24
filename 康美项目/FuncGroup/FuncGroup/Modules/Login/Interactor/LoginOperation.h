//
//  LoginOperation.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginOperProtocol.h"

typedef void (^result)(BOOL success,NSString *message);

@interface LoginOperation : NSObject

@property (nonatomic,weak) NSObject<LoginInOperProtocol> *loginInHandler;
@property (nonatomic,weak) NSObject<LoginOutOperProtocol> *loginOutHandler;
@property (nonatomic,weak) UIViewController<ForgetPsdOperProtocol> *forgetPsdHandler;

/*
 * 登录操作
 */
-(void)loginOperate:(NSString *)phoneNum password:(NSString *)psd;

-(void)loginOutOperate;

/*
 * 找回密码操作
 */
-(void)beginGetForgetPasswordVetifyCode:(NSString *)phoneNum block:(result)block;

-(void)forgetPasswordOperate:(NSString *)phoneNum verifyCode:(NSString *)verifyCode password:(NSString *)psd cardID:(NSString *)cardID;

+(void)savePsdYesOrNot:(BOOL)save;

-(NSDictionary *)getLocalUserInfo;


@end
