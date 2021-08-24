//
//  UIViewController+KMRoute.m
//  YiYangCloud
//
//  Created by gary on 2017/4/12.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "UIViewController+KMRoute.h"
#import <objc/runtime.h>
#import "KMRouteRequest.h"

@implementation UIViewController (KMRoute)
@dynamic routeRequest;

-(KMRouteRequest *)routeRequest{
    return objc_getAssociatedObject(self, "routeRequest");
}

-(void)setRouteRequest:(KMRouteRequest *)routeRequest{
    objc_setAssociatedObject(self, "routeRequest", routeRequest, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+(void)load{
    [self exchangeMethodWithClass:[self class] originalSelector:sel_getUid("viewDidDisappear:") swizzledSelector:@selector(wlr_viewDidDisappearSwzzled:)];
}
-(void)wlr_viewDidDisappearSwzzled:(BOOL)animated{
    NSLog(@"wlr_viewDidDisappearSwzzled");
    if (self.routeRequest != nil && self.routeRequest.isConsumed == NO) {
        [self.routeRequest defaultFinishTargetCallBack];
    }
    self.routeRequest = nil;
    [self wlr_viewDidDisappearSwzzled:animated];
}
+(void)exchangeMethodWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    /*
     如果这个类没有实现 originalSelector ，但其父类实现了，那 class_getInstanceMethod 会返回父类的方法。这样 method_exchangeImplementations 替换的是父类的那个方法，这当然不是你想要的。所以我们先尝试添加 orginalSelector ，如果已经存在，再用 method_exchangeImplementations 把原方法的实现跟新的方法实现给交换掉。
     */
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}
@end
