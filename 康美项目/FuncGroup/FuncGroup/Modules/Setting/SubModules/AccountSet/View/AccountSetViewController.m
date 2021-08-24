//
//  AccountSetViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/10.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "AccountSetViewController.h"

@interface AccountSetViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *textField_name;
@property (weak, nonatomic) IBOutlet UITextField *textField_psd;
@property (weak, nonatomic) IBOutlet UITextField *textField_name_new;
@property (weak, nonatomic) IBOutlet UITextField *textField_psd_new;
@property (weak, nonatomic) IBOutlet UITextField *textField_psd_new_re;
@property (weak, nonatomic) IBOutlet UITextField *textField_realName;
@property (weak, nonatomic) IBOutlet UITextField *textField_cardID;
@property (weak, nonatomic) IBOutlet UITextField *textField_telephone;


@end

@implementation AccountSetViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self layoutNaviBarViewWithTitle:@"账号信息管理"];
}

- (IBAction)saveDataButtonClick:(id)sender {
    [self.presenter accountSet:G_dict(_textField_name.placeholder, _textField_name.text)  password:G_dict(_textField_psd.placeholder,_textField_psd.text) newName:G_dict(_textField_name_new.placeholder,_textField_name_new.text) newPassword:G_dict(_textField_psd_new.placeholder,_textField_psd_new.text) rePSD:G_dict(_textField_psd_new_re.placeholder,_textField_psd_new_re.text) realName:G_dict(_textField_realName.placeholder,_textField_realName.text) cardIDNum:G_dict(_textField_cardID.placeholder,_textField_cardID.text) telephoneNum:G_dict(_textField_telephone.placeholder,_textField_telephone.text)];
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
