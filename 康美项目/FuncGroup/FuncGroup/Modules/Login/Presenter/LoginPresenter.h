//
//  LoginPresenter.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresenterOutput.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ForgetPsdViewController.h"
#import "LoginOperation.h"
#import "RegistOperation.h"

@interface LoginPresenter : UIViewController<PresenterOutput,LoginVCProtocol,LoginInOperProtocol,RegistOperProtocol,RegistVCProtocol,ForgetPsdVCProtocol,ForgetPsdOperProtocol>



@end
