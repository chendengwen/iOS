//
//  UserGuideViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/7.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "UserGuideViewController.h"
#import "AppDelegate.h"
#import "AppCacheManager.h"
@interface UserGuideViewController ()

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_zy"]];
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    imgV.userInteractionEnabled = true;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jtq_zyView:)];
    [imgV addGestureRecognizer:tap];
    // 保存用户数据  保存缓存
    
}

- (void)jtq_zyView:(UITapGestureRecognizer *)tapV{
    [tapV.view removeFromSuperview];
    UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jtq_zy"]];
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    imgV.userInteractionEnabled = true;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissImgV)];
    [imgV addGestureRecognizer:tap];
}

- (void)dismissImgV{
    [[AppCacheManager sharedAppCacheManager] setAppCache:@(AppStateLogined) forKey:kAppStatus];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.launchRouter installRootViewControllerIntoWindow:appDelegate.window];
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
