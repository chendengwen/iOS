//
//  RegistViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "RegistViewController.h"
#import "UIImage+Additions.h"
#import "YiYangCloud-Swift.h"

@interface RegistViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField_1;
@property (weak, nonatomic) IBOutlet UITextField *textField_2;
@property (weak, nonatomic) IBOutlet UITextField *textField_3;
@property (weak, nonatomic) IBOutlet UITextField *textField_4;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (nonatomic, assign, getter = isKeyboardShowed) BOOL keyboardShowed;

@end

@implementation RegistViewController
{
    HtmlViewController *_protocolCtl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark ===
-(IBAction)backButtonClick:(id)sender{
    [self.presenter registSegmentControlClick];
}

- (IBAction)agreeRegistProtocol:(id)sender {
    UIButton *button = (UIButton *)sender;
    _agreeButton.selected = !button.selected;
}

- (IBAction)getVerifyCodeClicked:(id)sender {
    [self.presenter getVerifyCodeClicked:_textField_1.text];
}

- (IBAction)submitButtonClicked:(id)sender {
    if (!_agreeButton.selected) {
        [SVProgressHUD showErrorWithStatus:@"请阅读并同意注册协议"];
    }else {
        [self.presenter beginRegist:_textField_1.text password:_textField_2.text rePsd:_textField_3.text verifyNum:_textField_4.text];
    }
}

- (IBAction)gotoProtocol:(id)sender {
    _protocolCtl = [[HtmlViewController alloc] init];
    _protocolCtl.title = @"医养云注册协议";
    _protocolCtl.fileName = @"policy_zh";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissProtocol) forControlEvents:UIControlEventTouchUpInside];
    
    CustomNavigationBarView *navView = [[CustomNavigationBarView alloc] initWithTitle:@"注册协议" withLeftButton:button withRightButton:nil withBackColorStyle:NavigationBarViewBackColorWhite];
    _protocolCtl.webView.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight);
    [_protocolCtl.view addSubview:navView];
    
    [self presentViewController:_protocolCtl animated:YES completion:nil];
}

-(void)dismissProtocol{
    [_protocolCtl dismissViewControllerAnimated:YES completion:nil];
}


@end
