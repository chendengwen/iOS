//
//  GeneralSettingViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/13.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "GeneralSettingViewController.h"
#import "GeneralSettingInteractor.h"


@interface GeneralSettingViewController ()
{
    
}

@property (strong, nonatomic) GeneralSettingInteractor *interactor;

@property (weak, nonatomic) IBOutlet UISwitch *segment_1;
@property (weak, nonatomic) IBOutlet UISwitch *segment_2;

@property (weak, nonatomic) IBOutlet UIView *bgView_switchView_2;
@property (weak, nonatomic) IBOutlet UITextField *textField_1;
@property (weak, nonatomic) IBOutlet UITextField *textField_2;


@end

@implementation GeneralSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self layoutNaviBarViewWithTitle:@"通用设置"];
    
    self.textField_1.text = [self.interactor getInterface];
    self.textField_2.text = [self.interactor getRecordUrl];
    
    [self.interactor getdemonstrateOff] && (_segment_1.on = YES);
//    ![self.interactor getSiteOff] && (_segment_2.on = NO ) && (self.bgView_switchView_2.hidden = YES);
    if (![self.interactor getSiteOff]) {
        _segment_2.on = NO ;
        self.bgView_switchView_2.hidden = YES;
    }
}

-(GeneralSettingInteractor *)interactor{
    if (!_interactor) {
        _interactor = [[GeneralSettingInteractor alloc] init];
    }
    return _interactor;
}

#pragma mark === ButtonClick
- (IBAction)switchClick_1:(id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    [self.interactor setdemonstrateOff:switchBtn.on];
}

- (IBAction)switchClick_2:(id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    self.bgView_switchView_2.hidden = !switchBtn.on;
    
    [self.interactor setSiteOff:switchBtn.on];
}


- (IBAction)saveButtonClicked:(id)sender {
//    if (StringWithValue(_textField_1.text)) {
//        [SVProgressHUD showErrorWithStatus:@""];
//    }else if(StringWithValue(_textField_2.text)){
//        [SVProgressHUD showErrorWithStatus:@""];
//    }
    [self.interactor setInterface:_textField_1.text recordUrl:_textField_2.text];
    
    [self popBack];
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
