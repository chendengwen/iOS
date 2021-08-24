//
//  CommonPresenter.m
//  FuncGroup
//
//  Created by gary on 2017/2/9.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "CommonPresenter.h"
#import "CustomNavigationBarView.h"

@interface CommonPresenter()

@end

@implementation CommonPresenter

/*
 * 子类需要重写
 */
-(UIViewController *)getInterface{
    if (self.interface) {
        return self.interface;
    }else {
        return [[UIViewController alloc] init];
    }
}


    

@end
