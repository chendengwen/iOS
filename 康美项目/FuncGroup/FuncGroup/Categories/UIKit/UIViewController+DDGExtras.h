//
//  UIViewController+DDGExtras.h
//  ddgBank
//
//  Created by Cary on 14/12/30.
//  Copyright (c) 2014年 com.ddg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DDGExtras)

- (void)popBack;

-(UIBarButtonItem *)customRightBarButton;

-(UIBarButtonItem *)customLeftBarButton;

-(void)resignFirstResponder;


/**
 *  从后台进入前台的回调
 *
 *  @param notification 通知
 */
- (void)handleApplicationDidBecomeActiveNotification:(NSNotification *)notification;


@end
