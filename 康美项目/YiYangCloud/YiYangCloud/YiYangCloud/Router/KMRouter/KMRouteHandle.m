//
//  KMRouteHandle.m
//  YiYangCloud
//
//  Created by gary on 2017/4/12.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "KMRouteHandle.h"
#import "KMRouteRequest.h"
#import "UIViewController+KMRoute.h"

@implementation KMRouteHandle

-(BOOL)shouldHandleWithRequest:(KMRouteRequest *)request{
    return YES;
}
-(UIViewController *)targetViewControllerWithRequest:(KMRouteRequest *)request{
    return [[NSClassFromString(@"UIViewController") alloc]init];
}
-(UIViewController *)sourceViewControllerForTransitionWithRequest:(KMRouteRequest *)request{
    return [UIApplication sharedApplication].windows[0].rootViewController;
}
- (BOOL)preferModalPresentationWithRequest:(KMRouteRequest *)request;{
    return NO;
}

-(BOOL)handleRequest:(KMRouteRequest *)request error:(NSError *__autoreleasing *)error{
    UIViewController * sourceViewController = [self sourceViewControllerForTransitionWithRequest:request];
    UIViewController * targetViewController = [self targetViewControllerWithRequest:request];
    if ((![sourceViewController isKindOfClass:[UIViewController class]])||(![targetViewController isKindOfClass:[UIViewController class]])) {
//        *error = [NSError WLRTransitionError];
        return NO;
    }
    if (targetViewController != nil) {
        targetViewController.routeRequest = request;
    }
    BOOL isPreferModal = [self preferModalPresentationWithRequest:request];
    return [self transitionWithWithRequest:request sourceViewController:sourceViewController targetViewController:targetViewController isPreferModal:isPreferModal error:error];
}
-(BOOL)transitionWithWithRequest:(KMRouteRequest *)request sourceViewController:(UIViewController *)sourceViewController targetViewController:(UIViewController *)targetViewController isPreferModal:(BOOL)isPreferModal error:(NSError *__autoreleasing *)error{
    if (isPreferModal||![sourceViewController isKindOfClass:[UINavigationController class]]) {
        [sourceViewController presentViewController:targetViewController animated:YES completion:nil];
    }
    else if ([sourceViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController * nav = (UINavigationController *)sourceViewController;
        [nav pushViewController:targetViewController animated:YES];
    }
    return YES;
}



@end
