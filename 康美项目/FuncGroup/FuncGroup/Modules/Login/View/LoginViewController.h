//
//  LoginViewController.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginOperProtocol.h"

@protocol LoginVCProtocol <NSObject>

-(void)viewDidAppear;

-(void)beginLogin:(NSString *)usrName password:(NSString *)psd;

-(void)loginSegmentControlClick;

/*
 * @prama data:登录结束需要返回的数据（成功、失败等）
 */
//-(void)endLogin:(NSDictionary *)data;


@optional
-(void)remeberPsd:(BOOL)remeber;
-(void)forgetPsd;

@end

@interface LoginViewController : UIViewController

@property (nonatomic,strong) id<LoginVCProtocol> presenter;

@property (nonatomic,strong) NSDictionary *lastUserInfo;

@end
