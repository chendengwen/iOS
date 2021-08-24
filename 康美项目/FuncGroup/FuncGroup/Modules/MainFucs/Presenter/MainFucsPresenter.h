//
//  MainFucsPresenter.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresenterOutput.h"
#import "LoginOperProtocol.h"
#import "MainFucsViewController.h"

@interface MainFucsPresenter : NSObject<PresenterOutput,LoginOutVCProtocol,LoginOutOperProtocol>

@end
