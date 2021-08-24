//
//  UIViewController+DDGExtras.m
//  ddgBank
//
//  Created by Cary on 14/12/30.
//  Copyright (c) 2014年 com.ddg. All rights reserved.
//

#import "UIViewController+DDGExtras.h"
#import <objc/message.h>

@implementation UIViewController (DDGExtras)

+(void)load{
    Method method_origin = class_getInstanceMethod([UIViewController class], @selector(viewDidDisappear:));
    Method method_new = class_getInstanceMethod([UIViewController class], @selector(G_viewDidDisappear:));
    method_exchangeImplementations(method_origin, method_new);
}

#pragma mark === View life circle
// -(void)viewDidDisappear:(BOOL)animated
-(void)G_viewDidDisappear:(BOOL)animated{
    [self G_viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark ==== customBarButton
- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showOptionCtl{

}

#pragma mark ==== customBarButton
-(UIBarButtonItem *)customLeftBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    return item;
}

-(UIBarButtonItem *)customRightBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"option"] style:UIBarButtonItemStylePlain target:self action:@selector(showOptionCtl)];
    return item;
}


-(void)resignFirstResponder{
    [self.view resignFirstResponder];
}

- (void)handleApplicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [self.view endEditing:YES];
}


@end
