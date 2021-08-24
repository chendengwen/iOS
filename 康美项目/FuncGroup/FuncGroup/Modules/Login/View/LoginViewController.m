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

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITextField *textField_1;
@property (weak, nonatomic) IBOutlet UITextField *textField_2;
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
    
    [self layoutSegment];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _textField_1.text = self.lastUserInfo[kLastAccount];
    if (self.lastUserInfo[kPsdOff]) {
        self.rememberPsd.selected = [self.lastUserInfo[kPsdOff] boolValue];
        if ([self.lastUserInfo[kPsdOff] boolValue]) {
            _textField_2.text = self.lastUserInfo[kLastPsd];
        }
    }
}

-(void)layoutSegment{
    CGRect rect = _segmentControl.frame;
    rect.size.height = 40.0;
    _segmentControl.frame = rect;
    _segmentControl.layer.cornerRadius = 6;
    _segmentControl.clipsToBounds = YES;
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.tintColor = [UIColor whiteColor];
    _segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
    _segmentControl.layer.borderWidth = 0.7;
    
    // 设置字体大小
    UIFont* font = [UIFont fontWithName:@"TrebuchetMS" size:14];
    // 设置正常的字体颜色
    NSDictionary* textAttributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor whiteColor]};
    [_segmentControl setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    // 设置被选中的字体颜色
    textAttributes = @{NSFontAttributeName:font,
                       NSForegroundColorAttributeName:[Resource blueColor]};
    [_segmentControl setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
    
//    [_segmentControl setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segmentControl setBackgroundImage:[UIImage createImageWithColor:[Resource blueColor]] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [_segmentControl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
}

-(void)segmentClick:(id)sender{
    [self.presenter loginSegmentControlClick];
    _segmentControl.selectedSegmentIndex = 0;
}


#pragma mark == ClickFunction
- (IBAction)loginButtonClick:(id)sender {
    // 回调给展示器
    [self.presenter beginLogin:_textField_1.text password:_textField_2.text];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
