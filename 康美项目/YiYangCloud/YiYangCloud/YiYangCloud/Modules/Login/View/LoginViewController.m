//
//  LoginViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginOperation.h"
#import "UIImage+Additions.h"
#import "YiYangCloud-Swift.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField_1;
@property (weak, nonatomic) IBOutlet UITextField *textField_2;
@property (weak, nonatomic) IBOutlet UITextField *textField_3;
@property (weak, nonatomic) IBOutlet GenerateCodeView *generateCodeView;


@property (weak, nonatomic) IBOutlet UIButton *rememberPsd;

@property (nonatomic, assign, getter = isKeyboardShowed) BOOL keyboardShowed;
@end

@implementation LoginViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.presenter viewDidAppear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _textField_1.text = self.lastUserInfo[kLastAccount];
    if (self.lastUserInfo[kPsdOff]) {
        self.rememberPsd.selected = [self.lastUserInfo[kPsdOff] boolValue];
        if ([self.lastUserInfo[kPsdOff] boolValue]) {
            _textField_2.text = self.lastUserInfo[kLastPsd];
        }
    }
    
    [_generateCodeView CreateGenerateCodeAction];
}


#pragma mark == ClickFunction
- (IBAction)loginButtonClick:(id)sender {
    if ([[_generateCodeView.codeString lowercaseString] isEqualToString:[_textField_3.text lowercaseString]]) {
        // 回调给展示器
        [self.presenter beginLogin:_textField_1.text password:_textField_2.text];
    } else [SVProgressHUD showErrorWithStatus:@"验证码错误"];
}

- (IBAction)registButtonClick:(id)sender {
    [self.presenter loginSegmentControlClick];
}

- (IBAction)forgetButtonClick:(id)sender {
    [self.presenter forgetPsd];
}

- (IBAction)rememberPsd:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    [self.presenter remeberPsd:button.selected];
}

#pragma mark - notification handler
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    if (!self.keyboardShowed) {
        [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -80);
        }];
        
        self.keyboardShowed = YES;
    }
}

-(void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
    
    self.keyboardShowed = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
