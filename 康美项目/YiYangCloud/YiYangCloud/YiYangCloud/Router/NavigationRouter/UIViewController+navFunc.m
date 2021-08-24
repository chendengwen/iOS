//
//  UIViewController+navFunc.m
//  FuncGroup
//
//  Created by gary on 2017/2/6.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "UIViewController+navFunc.h"
#import <objc/runtime.h>
#import "CustomNavigationBarView.h"

static const void *ParamDicKey = &ParamDicKey;
static const void *PreviousVCKey = &PreviousVCKey;

@implementation UIViewController (navFunc)


-(void)pushToVC:(NSString *)vcName{
    if (vcName != nil && vcName.length > 5) {
        [self pushToVC:vcName params:nil animate:YES];
    }
#ifdef Debug
    else {
        printf("当前跳转页面类名为空  无法跳转，请检查！！！");
    }
#endif
}

-(void)pushToVC:(NSString *)vcName params:(NSDictionary *)dic{
    [self pushToVC:vcName params:dic animate:YES];
}

-(void)pushToVC:(NSString *)vcName params:(NSDictionary *)dic animate:(BOOL)animate{
    if (vcName == nil) {
        printf("%s 当前类名为空",__func__);
    }else {
        printf("%s 当前类名为 %s",__func__, [vcName UTF8String]);
        
        UIViewController *vc = initialVCFromName(vcName, dic);
        vc.previousVC = self;
        [self.navigationController showViewController:vc sender:nil];
    }
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)popBackAnimation:(BOOL)animation{
    [self.navigationController popViewControllerAnimated:animation];
}

UIViewController* initialVCFromName(NSString *vcName, NSDictionary *dic){
    Class cls = NSClassFromString(vcName);
    id obj = [[cls alloc] init];
    
    UIViewController *ctl;
    SEL selector = NSSelectorFromString(@"getInterface");
    if ( [obj respondsToSelector:selector] == YES) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        ctl = [obj performSelector:selector];
#pragma clang diagnostic pop
        // add paramsDic
        if (dic) {
            objc_setAssociatedObject(ctl, ParamDicKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        return ctl;
    }else {
        // add paramsDic
        if (dic) {
            objc_setAssociatedObject(obj, ParamDicKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return (UIViewController *)obj;
    }
    
    return nil;
}

+(UIViewController *)initialVCFromName:(NSString *)vcName params:(NSDictionary *)dic{
    Class cls = NSClassFromString(vcName);
    /* runtime msgsend call initWithName*/
    UIViewController *ctl = [[cls alloc] init];
    
    return ctl;
}

#pragma mark === 参数
/*
 * paramDic
 */
-(NSDictionary *)paramDic{
    return objc_getAssociatedObject(self, ParamDicKey);
}

/*
 * previousVC
 */
-(UIViewController *)previousVC{
    return objc_getAssociatedObject(self, PreviousVCKey);
}

-(void)setPreviousVC:(UIViewController *)previousVC{
    objc_setAssociatedObject(self, PreviousVCKey, previousVC, OBJC_ASSOCIATION_ASSIGN);
}



#pragma mark ==== Layout-UI
-(CustomNavigationBarView *)layoutNaviBarViewWithTitle:(NSString *)title hideBackButton:(BOOL)hide{
    
    if (hide) {
        return [self getNaviBarView:title];
    }else{
        return [self layoutNaviBarViewWithTitle:title];
    }
    
}

-(CustomNavigationBarView *)layoutNaviBarViewWithTitle:(NSString *)title{
    
    UIButton *buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    buttonLeft.tag = 10011;
    
    SEL selector = NSSelectorFromString(@"popBack");
    [buttonLeft addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    CustomNavigationBarView *navBarView = [[CustomNavigationBarView alloc] initWithTitle:title withLeftButton:buttonLeft withRightButton:nil withBackColorStyle:NavigationBarViewBackColorBlack];
    
    [self.view addSubview:navBarView];
    
    return navBarView;
}

-(CustomNavigationBarView *)getNaviBarView:(NSString *)title{
    CustomNavigationBarView *navBarView = [[CustomNavigationBarView alloc] initWithTitle:title withLeftButton:nil withRightButton:nil withBackColorStyle:NavigationBarViewBackColorBlack];
    [self.view addSubview:navBarView];
    
    return navBarView;
}

@end
