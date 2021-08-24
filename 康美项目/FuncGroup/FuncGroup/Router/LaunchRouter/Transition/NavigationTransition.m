//
//  NavigationTransition.m
//  FuncGroup
//
//  Created by gary on 2017/2/27.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "NavigationTransition.h"

@implementation NavigationTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromCtl = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toCtl = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = fromCtl.view;
    UIView *toView = toCtl.view;
    
    [containerView addSubview:toView];
    
//    [[transitionContext containerView] bringSubviewToFront:fromView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromView.alpha = 0.0;
        fromView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        toView.alpha = 1.0;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformMakeScale(1, 1);
        [transitionContext completeTransition:YES];
    }];
}

@end
