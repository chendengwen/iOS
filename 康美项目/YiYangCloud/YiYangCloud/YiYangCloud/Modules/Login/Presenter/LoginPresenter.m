//
//  LoginPresenter.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "LoginPresenter.h"
#import "AppDelegate.h"
#import "LocalWebView.h"

static NSString *LoginViewControllerIdentifier = @"LoginViewController";
static NSString *RegistViewControllerIdentifier = @"RegistViewController";
static NSString *ForgetPsdViewControllerIdentifier = @"ForgetPsdViewController";

@interface LoginPresenter()<WKNavigationDelegate,UIWebViewDelegate>
{
    LocalWebView *_webView;
    int _index;
    
    LoginViewController *_ctl_1;
    RegistViewController *_ctl_2;
    ForgetPsdViewController *_ctl_3;
    
    RegistOperation *_operationRegist;
    
}

@property (nonatomic ,strong) LoginOperation *operationLogin;

@property (nonatomic, strong) UIViewController *interface;

@end

@implementation LoginPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(UIViewController *)getInterface{    
    
    return [self viewControllerFromStoryboard];
}

- (UIViewController *)viewControllerFromStoryboard{
    UIStoryboard *storyboard = [self storyboard];
    _ctl_1 = [storyboard instantiateViewControllerWithIdentifier:LoginViewControllerIdentifier];
    _ctl_1.presenter = self;
    _ctl_1.lastUserInfo = [self.operationLogin getLocalUserInfo];
    self.interface = _ctl_1;
    
    _ctl_2 = [storyboard instantiateViewControllerWithIdentifier: RegistViewControllerIdentifier];
    _ctl_2.presenter = self;
    
    _ctl_3 = [storyboard instantiateViewControllerWithIdentifier: ForgetPsdViewControllerIdentifier];
    _ctl_3.presenter = self;
    
    [self addChildViewController:_ctl_1];
    [self addChildViewController:_ctl_2];
    [self addChildViewController:_ctl_3];
    
    [self.view addSubview:_ctl_1.view];
    self.interface = _ctl_1;
    
    return self;
}

- (UIStoryboard *)storyboard{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginRegist"
                                                         bundle:[NSBundle mainBundle]];
    return storyboard;
}

-(LoginOperation *)operationLogin{
    if (!_operationLogin) {
        _operationLogin = [[LoginOperation alloc] init];
        _operationLogin.loginInHandler = self;
        _operationLogin.forgetPsdHandler = self;
    }
    return  _operationLogin;
}

//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    kWeakSelf(self)
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            weakself.interface = newController;
            
            if (weakself.interface == _ctl_1) {
                [self showSystemTips];
            }
        }else{
            weakself.interface = oldController;
        }
    }];
}


-(void)endLoginRegistOperation:(NSDictionary *)data{

    BOOL result = [[data objectForKey:@"success"] boolValue];
    if (result) {
        //结束登录操作，做相应的交互处理: 等待框 跳页面等
        [SVProgressHUD dismiss];
        // 切换根视图
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.launchRouter installRootViewControllerIntoWindow:appDelegate.window];
    }else{
        [SVProgressHUD showErrorWithStatus:data[@"msg"]];
    }
}

#pragma mark === WebViewFunc
-(void)showSystemTips{
    return;
    if (self.interface != _ctl_1) return;
    
    if (!_webView) {
        float width = 400.0, height = 250.0;
        _webView = [[LocalWebView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width)/2, SCREEN_HEIGHT, width, height)];
        _webView.cornerRadius = 4.0;
        [_webView loadFile:@"SystemTips" delegate:self];
        _webView.scrollView.scrollEnabled = NO;
        
        [self.interface.view addSubview:_webView];
        
        [self webViewAddContextFunction];
    }
    
    [UIView animateKeyframesWithDuration:0.4 delay:0.1 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        _webView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    } completion:nil];
}

-(void)webViewAddContextFunction{
    kWeakSelf(_webView)
    [_webView addContextFunction:@"dismissView" block:^{
        [UIView animateWithDuration:0.4 animations:^{
            weak_webView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+weak_webView.bounds.size.height);
        } completion:^(BOOL finished) {
            if (finished) {
                [weak_webView removeFromSuperview];
            }
        }];
        
    }];
}


-(void)viewDidAppear{
    
    [self showSystemTips];
}

#pragma mark === LoginVCPProtocol
-(void)beginLogin:(NSString *)usrName password:(NSString *)psd{
    // 开始登录操作，做相应的交互处理: 等待框等
    [SVProgressHUD showWithStatus:@"正在登录..."];
    
    // 调用交互器做数据处理
    [self.operationLogin loginOperate:usrName password:psd];
}

-(void)loginSegmentControlClick{
    if (_index == 0) {
        [self replaceController:self.interface newController:_ctl_2];
        _index = 1;
    }
}

-(void)forgetPsd{
    [self replaceController:self.interface newController:_ctl_3];
    _index = 2;
}

-(void)remeberPsd:(BOOL)remeber{
    [LoginOperation savePsdYesOrNot:remeber];
}

#pragma mark === LoginInOperProtocol
-(void)loginStateReacte:(NSString *)state{
    [SVProgressHUD showErrorWithStatus:state];
}

-(void)loginSuccessed:(NSDictionary *)dataDic{
    [self endLoginRegistOperation:dataDic];
}

-(void)loginFailed:(NSDictionary *)dataDic{
    [self endLoginRegistOperation:dataDic];
}

#pragma mark === LoginOutVCProtocol
-(void)endLoginOut:(NSDictionary *)data{
    
}

#pragma mark === RegistVCProtocol
-(void)registSegmentControlClick{
    if (_index == 1) {
        [self replaceController:self.interface newController:_ctl_1];
        _index = 0;
    }
}

-(void)beginRegist:(NSString *)phoneNum password:(NSString *)psd rePsd:(NSString *)rePsd verifyNum:(NSString *)verifyNum{
    [SVProgressHUD showWithStatus:@"正在注册..."];
    
    // 调用交互器做数据处理
    if (!_operationRegist) {
        _operationRegist = [[RegistOperation alloc] init];
        _operationRegist.handler = self;
    }
    [_operationRegist registOperate:phoneNum password:psd rePsd:rePsd verifyNum:verifyNum];
}

-(void)registProtocol{
    [self.interface pushToVC:@""];
}

-(void)getVerifyCodeClicked:(NSString *)phoneNum{
    // 调用交互器做数据处理
    if (!_operationRegist) {
        _operationRegist = [[RegistOperation alloc] init];
        _operationRegist.handler = self;
    }
    
    [SVProgressHUD showWithStatus:@"正在发送验证码..."];
    [_operationRegist getRegistVetifyCode:phoneNum];
}

#pragma mark === RegistOperProtocol
-(void)registStateReacte:(NSString *)state{
    [SVProgressHUD showErrorWithStatus:state];
}

-(void)registSuccessed:(NSDictionary *)dataDic{
    // 需要再登录
    [self switchToLogin];
    // 不需要再登录直接进入
//    [self endLoginRegistOperation:dataDic];
}

-(void)registFailed:(NSDictionary *)dataDic{
    [self endLoginRegistOperation:dataDic];
}

-(void)getRegistVeriyfCodeSuccessed:(NSString *)message{
    [SVProgressHUD showSuccessWithStatus:message];
}

-(void)getRegistVeriyfCodeFailed:(NSString *)message{
    [SVProgressHUD showErrorWithStatus:message];
}

#pragma mark === ForgetPsdVCProtocol
-(void)beginGetForgetPasswordVetifyCode:(NSString *)phoneNum block:(result)block{
    [SVProgressHUD showWithStatus:@"正在发送验证码..."];
    [self.operationLogin beginGetForgetPasswordVetifyCode:phoneNum block:^(BOOL success, NSString *message) {
        block(success,message);
    }];
}

-(void)beginFindPsdWithPhoneNum:(NSString *)phoneNum verifyNum:(NSString *)verifyNum password:(NSString *)psd cardID:(NSString *)cardID{
    [SVProgressHUD showWithStatus:@"密码重置中..."];
    [self.operationLogin forgetPasswordOperate:phoneNum verifyCode:verifyNum password:psd cardID:cardID];
}

-(void)switchToLogin{
    [self replaceController:self.interface newController:_ctl_1];
    _index = 0;
}

-(void)switchToRegist{
    [self replaceController:self.interface newController:_ctl_2];
    _index = 1;
}

#pragma mark === ForgetPsdOperProtocol
-(void)fixPasswordStateReacte:(NSString *)state{
    [SVProgressHUD showErrorWithStatus:state];
}

-(void)fixPasswordSuccessed:(NSDictionary *)dataDic{
    
    [SVProgressHUD showSuccessWithStatus:dataDic[kMsg]];
    [self switchToLogin];
}

-(void)fixPasswordFailed:(NSDictionary *)dataDic{
    [SVProgressHUD showErrorWithStatus:dataDic[kMsg]];
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden
}


@end
