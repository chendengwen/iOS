//
//  MainFucsViewController.h
//  FuncGroup
//
//  Created by gary on 2017/2/8.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginOutVCProtocol.h"
#import "PresenterOutput.h"

@interface MainFucsViewController : UIViewController

@property (nonatomic,strong) id<LoginOutVCProtocol,PresenterOutput> presenter;

@end
