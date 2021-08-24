//
//  LaunchRouter.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LaunchRouter.h"
#import "YiYangCloud-Swift.h"

#import "AppCacheManager.h"
#import "idAdditions.h"

#import "NavigationTransition.h"
#import "NavigationInteractionTransition.h"

@interface LaunchRouter()<UINavigationControllerDelegate>

@property (nonatomic,strong) NavigationInteractionTransition *popInteraction;
@property (nonatomic,strong) NavigationTransition *pushAnimation;

@end

@implementation LaunchRouter

- (id)init
{
    if ((self = [super init])){
        
        [self configureDependencies];
    }
    
    return self;
}

- (void)configureDependencies{
    
}

#pragma mark === 路由器初始根视图
- (void)installRootViewControllerIntoWindow:(UIWindow *)window
{
    id<idAdditions> appStatus = [[AppCacheManager sharedAppCacheManager] cacheForKey:@"appStatus"];
    
    NSArray *classArr = @[@"UserGuidePresenter",@"LoginPresenter",@"YiYangCloud.TabBarPresenter"];
    Class cls = NSClassFromString([classArr objectAtIndex:appStatus ? [appStatus intValue]:1]);
    if (cls) {
        UIViewController *vc = [[[cls alloc] init] getInterface];
        [self showRootViewController:vc inWindow:window];
    }
}

#pragma mark === 展示和切换根视图
/*
 * 提供给展示器的接口 LoginPresenter/EntrancePresenter/UserGuidePresenter
 */
- (void)showRootViewController:(UIViewController *)viewController
                      inWindow:(UIWindow *)window
{
    window.rootViewController = viewController;
}


#pragma mark === UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.popInteraction writeToViewController:viewController];
}

/************************* 设置方法设置导航控制器支持的设备方向 ***************************/
- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

/************************* 下面两个方法可以对导航的转场动画进行设置 ***************************/
// interactive动画可以根据输入信息的变化改变动画的进程。例如iOS系统为UINavigationController提供的默认右滑退出手势就是一个interactive 动画，整个动画的进程由用户手指的移动距离控制。
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(nonnull id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.popInteraction.isActing ? self.popInteraction : nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0){
    if (operation == UINavigationControllerOperationPush) {
        return self.pushAnimation;
    }
    return nil;
}


-(NavigationTransition *)pushAnimation{
    if (!_pushAnimation) {
        _pushAnimation = [NavigationTransition new];
    }
    return _pushAnimation;
}

-(NavigationInteractionTransition *)popInteraction{
    if (!_popInteraction) {
        _popInteraction = [NavigationInteractionTransition new];
    }
    return _popInteraction;
}


@end
