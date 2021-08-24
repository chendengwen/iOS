//
//  NavigationInteractionTransition.m
//  FuncGroup
//
//  Created by gary on 2017/2/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "NavigationInteractionTransition.h"


@interface NavigationInteractionTransition()

@property (assign,nonatomic) BOOL canReceive;

@property (strong,nonatomic) UIViewController *remCtl;

@end

@implementation NavigationInteractionTransition

-(void)writeToViewController:(UIViewController *)toCtl{
    self.remCtl = toCtl;
    [self addPanGestureRecognizer:toCtl.view];
}

-(void)addPanGestureRecognizer:(UIView *)view{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)];
    [view addGestureRecognizer:pan];
}

/*
 我们在一开始的时候做出判断，只在前半屏幕响应Pop，然后在移动过程中持续的对滑动位置做判断，必须滑至后半段才允许执行Pop，在这其间我们一直用updateInteractiveTransition:方法更新Pop的滑动进度，最后在结束阶段，我们通过BOOL值的判断来完成取消这次Pop（cancelInteractiveTransition）还是完成这次Pop（finishInteractiveTransition）
 */
-(void)panRecognizer:(UIPanGestureRecognizer *)pan{
    CGPoint panPoint = [pan translationInView:pan.view.superview];
    CGPoint locationPoint = [pan locationInView:pan.view.superview];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.isActing = YES;
        
        // 判断初始位置，在屏幕前半段才能触发pop
        if (locationPoint.x <= self.remCtl.view.bounds.size.width/2.0) {
            [self.remCtl.navigationController popViewControllerAnimated:YES];
        }
    }else if (pan.state == UIGestureRecognizerStateChanged){
        if (locationPoint.x >= self.remCtl.view.bounds.size.width/2.0) {
            self.canReceive = YES;
        }else self.canReceive = NO;
        [self updateInteractiveTransition:panPoint.x/self.remCtl.view.bounds.size.width];
    }else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded){
        self.isActing = NO;
        if (!self.canReceive || pan.state == UIGestureRecognizerStateCancelled) {
            [self cancelInteractiveTransition];
        }else [self finishInteractiveTransition];
    }
}

@end
