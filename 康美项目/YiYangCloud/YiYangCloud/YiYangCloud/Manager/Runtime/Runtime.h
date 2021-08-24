//
//  Runtime.h
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Runtime : NSObject

/**
 * Swap two class instance method implementations.
 */
FOUNDATION_EXPORT void GSwapInstanceMethods(Class cls, SEL originalSel, SEL newSel);

/**
 * Swap two class method implementations.
 */
FOUNDATION_EXPORT void GSwapClassMethods(Class cls, SEL originalSel, SEL newSel);

/**
 *  @brief 用于替换根viewController, ios 3.2的系统未经测试
 */
FOUNDATION_EXPORT void GReplaceRootViewWithController(UIViewController *oldViewController, UIViewController *newViewController);


@end
