//
//  EntrancePresenter.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresenterOutput.h"
#import "LoginOperProtocol.h"
#import "EntranceViewController.h"

extern NSString *const EntranceViewControllerIdentifier;

@interface EntrancePresenter : NSObject<PresenterOutput,LoginOutVCProtocol,NavVCProtocol,LoginOutOperProtocol>

@end
