//
//  MainFucsViewController.m
//  FuncGroup
//
//  Created by gary on 2017/2/8.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "MainFucsViewController.h"
#import "AppCacheManager.h"

//#import "GChainUI.h"

@interface MainFucsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImgV;

@end

@implementation MainFucsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutUserData) name:kNotificationUserSwith object:nil];
    
//    UILabel *label = (UILabel *)[UILabel layout_make:^(id<ChainUIProtocol> gview) {
//        gview.G_title(@"wedqwefqwefqwef").G_backgroundColor([UIColor redColor]).G_origin(CGPointMake(400, 100));
//    }];
//    [self.view addSubview:label];
}

- (void)viewWillAppear:(BOOL)animated{
    [self layoutUserData];
}

-(void)layoutUserData{
    _userAvatarImgV.layer.cornerRadius = 60;
    _userAvatarImgV.layer.masksToBounds = YES;
    
    NSDictionary *dic = [self.presenter performGetDataFunctionWith:nil];
    _userNameLabel.text = dic[KCurrentName];
    _userIDLabel.text = dic[KIdCard];
    NSData *imgData = dic[KUserAvatar];
    if (imgData && imgData.length > 0) {
        _userAvatarImgV.image = [UIImage imageWithData:dic[KUserAvatar]];
    }else{
        _userAvatarImgV.image = [UIImage imageNamed:@"avatar"];
    }
}

-(void)gotoFunctionCtlAtIndex:(int)index{
    [self.presenter performFunctionWith:@(index)];
}

#pragma mark === FunctionButtonClick
- (IBAction)functionButtonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self gotoFunctionCtlAtIndex:(int)btn.tag-1210];
}

- (IBAction)popBack:(id)sender {
    [self popBack];
}

- (IBAction)loginOut:(id)sender {
//    // 通知上级页面EntranceViewController来处理登出操作
//    [self.previousVC functionFinishedWith:nil];
    
    // 开始登出操作，做相应的交互处理: 等待框等
    SIEditAlertView *alertView = [[SIEditAlertView alloc] initWithTitle:@"退出" andMessage:@"确认退出登录?"];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeDefault
                          handler:nil];
    [alertView addButtonWithTitle:@"确定"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIEditAlertView *alertView) {
                              // 调用交互器做数据处理
                              [self.presenter beginLoginOut];
                          }];
    
    alertView.showFieldEditView = YES;
    alertView.cornerRadius = 5;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
    
    [alertView show];
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
