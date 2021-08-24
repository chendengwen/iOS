//
//  Runtime.m
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "Runtime.h"
#import <objc/runtime.h>

@implementation Runtime

void GSwapInstanceMethods(Class cls, SEL originalSel, SEL newSel)
{
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    method_exchangeImplementations(originalMethod, newMethod);
}

void GSwapClassMethods(Class cls, SEL originalSel, SEL newSel)
{
    Method originalMethod = class_getClassMethod(cls, originalSel);
    Method newMethod = class_getClassMethod(cls, newSel);
    method_exchangeImplementations(originalMethod, newMethod);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
void GReplaceRootViewWithController(UIViewController *oldViewController, UIViewController *newViewController)
{
    id delegate = [UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(setRootViewController:)])
        [delegate performSelector:@selector(setRootViewController:) withObject:newViewController];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow respondsToSelector:@selector(setRootViewController:)])
        keyWindow.rootViewController = newViewController;
    else {
        [oldViewController.view removeFromSuperview];
        [keyWindow addSubview:newViewController.view];
    }
}

@end
