//
//  ForgetPsdViewController.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^result)(BOOL success,NSString *message);

@protocol ForgetPsdVCProtocol <NSObject>

/*!
  获取验证码
 */
-(void)beginGetForgetPasswordVetifyCode:(NSString *)phoneNum block:(result)block;
/*!
  找回密码
 */
-(void)beginFindPsdWithPhoneNum:(NSString *)phoneNum verifyNum:(NSString *)verifyNum password:(NSString *)psd cardID:(NSString *)cardID;

-(void)switchToLogin;
-(void)switchToRegist;

@end

@interface ForgetPsdViewController : UIViewController

@property (nonatomic,strong) id<ForgetPsdVCProtocol> presenter;

@end
