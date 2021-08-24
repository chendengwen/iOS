//
//  PresenterOutput.h
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PresenterOutput <NSObject>

//@property (nonatomic, strong) UIViewController *interface;

-(UIViewController *)getInterface;

@optional
// view层用来回调展示器层
-(void)performFunctionWith:(id)params;

// view层回调展示器层来获取数据
-(id)performGetDataFunctionWith:(id)params;

@end
