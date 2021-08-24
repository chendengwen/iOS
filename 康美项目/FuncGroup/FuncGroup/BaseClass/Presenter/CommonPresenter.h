//
//  CommonPresenter.h
//  FuncGroup
//
//  Created by gary on 2017/2/9.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresenterOutput.h"

@class CustomNavigationBarView;

@interface CommonPresenter : NSObject<PresenterOutput>

@property (nonatomic, weak) UIViewController *interface;


@end
