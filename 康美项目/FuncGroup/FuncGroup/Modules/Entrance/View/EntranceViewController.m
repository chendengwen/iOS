//
//  EntranceViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "EntranceViewController.h"
#import "LoginOperation.h"

@interface EntranceViewController ()

@end

@implementation EntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark === ButtonClick
- (IBAction)entrance_1_Click:(id)sender {
    [self.presenter pushToFunctionVC:0];
}

- (IBAction)entrance_2_Click:(id)sender {
    [self.presenter pushToFunctionVC:1];
}

- (IBAction)helpButtonClick:(id)sender {
    [self.presenter pushToHelpVC];
}

- (IBAction)loginOutButtonClick:(id)sender {
    // 调用交互器做数据处理    
    [self.presenter beginLoginOut];
}



#pragma mark === NavVCProtocol
-(void)functionFinishedWith:(id)callbackParams{
    [self loginOutButtonClick:nil];
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
