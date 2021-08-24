//
//  NavigationInteractionTransition.h
//  FuncGroup
//
//  Created by gary on 2017/2/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationInteractionTransition : UIPercentDrivenInteractiveTransition

/*
 * 是否正在进行
 */
@property (assign,nonatomic) BOOL isActing;

/*
 * 写入二级ViewController
 */
-(void)writeToViewController:(UIViewController *)toCtl;

@end
