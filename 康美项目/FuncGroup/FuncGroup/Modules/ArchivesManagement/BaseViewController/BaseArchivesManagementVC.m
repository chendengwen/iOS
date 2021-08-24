//
//  BaseArchivesManagementVC.m
//  FuncGroup
//
//  Created by zhong on 2017/2/22.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "BaseArchivesManagementVC.h"

@interface BaseArchivesManagementVC ()

@end

@implementation BaseArchivesManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
}

#pragma mark - Action
- (void)didClickBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBackBtn{
    //返回按钮
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.backgroundColor = [UIColor colorWithRed:0.43 green:0.44 blue:0.44 alpha:0.6];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(50));
    }];
    [backBtn addTarget:self action:@selector(didClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
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
