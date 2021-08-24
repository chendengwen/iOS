//
//  EntrancePresenter.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "EntrancePresenter.h"
#import "EntranceViewController.h"
#import "AppDelegate.h"
#import "LoginOperation.h"

NSString *const EntranceViewControllerIdentifier = @"EntranceViewController";

@interface EntrancePresenter()

@property (nonatomic ,strong) LoginOperation *operationLogin;

@property (nonatomic, strong) UIViewController *interface;

@end

@implementation EntrancePresenter


- (UIViewController *)getInterface
{
    UIStoryboard *storyboard = [self mainStoryboard];
    EntranceViewController *vc = [storyboard instantiateViewControllerWithIdentifier:EntranceViewControllerIdentifier];
    vc.presenter = self;
    self.interface = vc;
    
    return vc;
}


- (UIStoryboard *)mainStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    return storyboard;
}

-(LoginOperation *)operationLogin{
    if (!_operationLogin) {
        _operationLogin = [[LoginOperation alloc] init];
        _operationLogin.loginOutHandler = self;
    }
    return  _operationLogin;
}

#pragma mark === LoginOtVCPProtocol
-(void)beginLoginOut{
    // 开始登出操作，做相应的交互处理: 等待框等
    [self.operationLogin loginOutOperate];
}

-(void)endLoginOut:(NSDictionary *)data{
    
    BOOL result = [[data objectForKey:@"success"] boolValue];
    if (result) {
        //结束登出操作，做相应的交互处理: 等待框 跳页面等
        [SVProgressHUD dismiss];
        // 切换根视图
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.launchRouter installRootViewControllerIntoWindow:appDelegate.window];
    }else{
        
    }
}

-(void)pushToFunctionVC:(int)index{
    NSArray *ctlArr = @[@"MainFucsViewController",@""];
    [self.interface pushToVC:ctlArr[index]];
}

-(void)pushToHelpVC{
    [self.interface pushToVC:@"HelpViewController"];
}

#pragma mark === LoginOutOperProtocol
-(void)loginOutStateReacte:(NSString *)state{
    
}

-(void)loginOutSuccessed:(NSDictionary *)dataDic{
    [self endLoginOut:dataDic];
}

-(void)loginOutFailed:(NSDictionary *)dataDic{
    [self endLoginOut:dataDic];
}


@end
