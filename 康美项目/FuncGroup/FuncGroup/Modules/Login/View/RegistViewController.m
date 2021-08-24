//
//  RegistViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/14.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "RegistViewController.h"
#import "UIImage+Additions.h"
#import "HtmlViewController.h"

@interface RegistViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITextField *textField_1;
@property (weak, nonatomic) IBOutlet UITextField *textField_2;
@property (weak, nonatomic) IBOutlet UITextField *textField_3;
@property (weak, nonatomic) IBOutlet UITextField *textField_4;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (nonatomic, assign, getter = isKeyboardShowed) BOOL keyboardShowed;


@end

@implementation RegistViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutSegment];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)layoutSegment{
    CGRect rect = _segmentControl.frame;
    rect.size.height = 40.0;
    _segmentControl.frame = rect;
    _segmentControl.layer.cornerRadius = 6;
    _segmentControl.clipsToBounds = YES;
    _segmentControl.selectedSegmentIndex = 1;
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

#pragma mark ===
-(void)segmentClick:(id)sender{
    [self.presenter registSegmentControlClick];
    _segmentControl.selectedSegmentIndex = 1;
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
    HtmlViewController *ctl = [[HtmlViewController alloc] init];
    ctl.title = @"康美健康云注册协议";
    ctl.fileName = @"policy_zh";
    [self.navigationController pushViewController:ctl animated:YES];
}


#pragma mark - notification handler
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    if (!self.keyboardShowed) {
        [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -120);
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
