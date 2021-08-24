//
//  ForgetPsdViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "ForgetPsdViewController.h"
#import "LoginOperation.h"

@interface ForgetPsdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField_1;
@property (weak, nonatomic) IBOutlet UITextField *textField_2;
@property (weak, nonatomic) IBOutlet UITextField *textField_3;
@property (weak, nonatomic) IBOutlet UITextField *textField_4;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;


@end

@implementation ForgetPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark === ButtonClicked
- (IBAction)geyVerifyButtonClicked:(id)sender {
    if (StringWithValue(_textField_1.text)) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"LoginError_NoName", @"LocalLanguage", nil)];
        return;
    }
    
    [self.presenter beginGetForgetPasswordVetifyCode:_textField_1.text block:^(BOOL success, NSString *message) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:message ?: @"验证码发送成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:message ?: @"验证码发送失败"];
        }
    }];
    
//    NSMutableArray *params = [NSMutableArray arrayWithCapacity:2];
//    [params addObject:_textField_1.text];
//    
//    [[AFNetworkManager sharedAFNetworkManager] GetRequestUrl:[URLs getFullLoginsAPI:get_verifyCode_forgetPassword] parametersArr:params successBlock:^(JsonResult *result) {
////        [self.handler getRegistVeriyfCodeSuccessed:@"验证码发送成功"];
//        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
//    } failBlock:^(JsonResult *result) {
////        [self.handler getRegistVeriyfCodeFailed:result.msg];
//        [SVProgressHUD showErrorWithStatus:result.msg ?: @"验证码发送失败"];
//    }];
}

- (IBAction)findPsdButtonClicked:(id)sender {
    [self.presenter beginFindPsdWithPhoneNum:_textField_1.text verifyNum:_textField_4.text password:_textField_2.text cardID:_textField_3.text];
}

- (IBAction)backButtonClick:(id)sender {
    [self.presenter switchToLogin];
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
