//
//  FeedBackViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UITextViewDelegate>
{
    int _questionType;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *textViewBg;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CustomNavigationBarView *navView = [self layoutNaviBarViewWithTitle:@"意见反馈"];
    [navView addSubview:[self submitButton]];
    
    self.textViewBg.layer.borderWidth = 0.4;
    self.textViewBg.layer.borderColor = [Resource midGrayColor].CGColor;
    self.textViewBg.layer.cornerRadius = 5.0;
}

-(UIButton *)submitButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH - 80.f,26.0,60.f, 28.0f);
    [button setTitle:@"提 交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.cornerRadius = 4.0;
    SEL selector = NSSelectorFromString(@"feedbackOperation");
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)feedbackOperation{
    [self resignFirstResponder];
    [self popBack];
    
    // 上传数据
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:nil forKey:kAccount];
//    
//    [[AFNetworkManager sharedAFNetworkManager] GetRequestUrl:[URLs urlWithSegmentAPI:fuc_loginAuth] parameters:params successBlock:^(JsonResult *result) {
//        
//    } failBlock:^(JsonResult *result) {
//        
//    }];
}

#pragma mark === UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"反馈类型选择" andMessage:nil];
    
    NSArray *titleArr = @[@"产品改进建议",@"功能性反馈",@"问题反馈",@"情感反馈"];
    for (int i = 0; i < titleArr.count; i ++) {
        NSString *title = titleArr[i];
        [alertView addButtonWithTitle:title
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  _questionType = i;
                                  _textField.text = title;
                              }];
    }
    
    alertView.cornerRadius = 5;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
    
    [alertView show];
    
    return NO;
}

#pragma mark === UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ((text != nil && text.length > 0) || textView.text.length > 0) {
        self.tipsLabel.hidden = YES;
    }else
        self.tipsLabel.hidden = NO;
    
    return YES;
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
