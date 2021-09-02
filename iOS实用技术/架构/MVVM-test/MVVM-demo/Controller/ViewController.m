//
//  ViewController.m
//  MVVM-demo
//
//  Created by gary on 2021/7/6.
//

#import "ViewController.h"
#import "HomeViewModel.h"
#import "HomeBannerView.h"
#import "HomeUserInfoView.h"
#import "HomeSubjectsView.h"

@interface ViewController ()
{
    HomeViewModel *_viewModel;
    HomeBannerView *_bannerView;
    HomeUserInfoView *_userInfoView;
    HomeSubjectsView *_subjectsView;
}
@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [HomeViewModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupContentView];
    
    [self bindViewModel];
}

- (void)setupContentView {
    _bannerView = [HomeBannerView new];
    _userInfoView = [HomeUserInfoView new];
    _subjectsView = [HomeSubjectsView new];
    
    [self.view addSubview:_bannerView];
    [self.view addSubview:_userInfoView];
    [self.view addSubview:_subjectsView];
}

-(void)bindViewModel{
    [_bannerView bindViewModel];
}


@end
