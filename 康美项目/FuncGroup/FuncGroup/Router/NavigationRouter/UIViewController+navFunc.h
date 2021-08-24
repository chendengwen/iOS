//
//  UIViewController+navFunc.h
//  FuncGroup
//
//  Created by gary on 2017/2/6.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavVCProtocol.h"

@class CustomNavigationBarView;

@interface UIViewController (navFunc)

// nav中的上一级vc
@property (nonatomic, weak, readonly) UIViewController<NavVCProtocol> *previousVC;

// 所有VC统配的参数字典(主要用于传递)
@property (nonatomic, strong, readonly) NSDictionary *paramDic;

/**
 *  下级跳转
 */
-(void)pushToVC:(NSString *)vcName;

-(void)pushToVC:(NSString *)vcName params:(NSDictionary *)dic;

-(void)pushToVC:(NSString *)vcName params:(NSDictionary *)dic animate:(BOOL)animate;

/**
 *  上级回退
 */
-(void)popBack;

-(void)popBackAnimation:(BOOL)animation;

// 导航条
-(CustomNavigationBarView *)layoutNaviBarViewWithTitle:(NSString *)title;

-(CustomNavigationBarView *)layoutNaviBarViewWithTitle:(NSString *)title hideBackButton:(BOOL)hide;

@end
