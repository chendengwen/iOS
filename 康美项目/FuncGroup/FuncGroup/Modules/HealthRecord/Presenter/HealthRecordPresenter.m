//
//  HealthRecordPresenter.m
//  FuncGroup
//
//  Created by gary on 2017/2/20.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "HealthRecordPresenter.h"
#import "UIImage+Additions.h"

@interface HealthRecordPresenter ()
{
    int _selectedIndex;
    UISegmentedControl *_segmentControl;
}
@property (nonatomic ,strong) HealthRecordViewController  *firstVC;
@property (nonatomic ,strong) HealthChartViewController *secondVC;
@property (nonatomic ,strong) UIViewController *currentVC;

@end

@implementation HealthRecordPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CustomNavigationBarView *custNavView = [self layoutNaviBarViewWithTitle:nil];
    [self layoutSegmentOn:custNavView];
    
    [self addChildViewControllers];
}

-(void)addChildViewControllers{
    CGRect frame = CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - NavHeight);
    
    self.firstVC = [[HealthRecordViewController alloc] init];
    self.secondVC = [[HealthChartViewController alloc] init];
    [self.firstVC.view setFrame:frame];
    [self.secondVC.view setFrame:frame];
    
    [self addChildViewController:_firstVC];
    [self addChildViewController:_secondVC];
    
    [self.view addSubview:_firstVC.view];
    _currentVC = _firstVC;
}

#pragma mark - 初始化segment
-(void)layoutSegmentOn:(UIView *)view
{
    // 初始化SegmentedControl
    NSArray *titleArr = @[@"健康记录",@"健康走势"];
    float segmentWidth = 210.0*ScaleSize;
    
    _segmentControl = [[UISegmentedControl alloc] initWithItems:titleArr];
    _segmentControl.frame = CGRectMake((SCREEN_WIDTH - segmentWidth)/2, 23.0, segmentWidth, 30.0);
    _segmentControl.layer.cornerRadius = 6;
    _segmentControl.clipsToBounds = YES;
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.tintColor = [UIColor whiteColor];
    _segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
    _segmentControl.layer.borderWidth = 0.7;
    
    UIFont* font = [UIFont fontWithName:@"TrebuchetMS" size:14];
    NSDictionary* textAttributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor whiteColor]};
    [_segmentControl setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    textAttributes = @{NSFontAttributeName:font,
                       NSForegroundColorAttributeName:[Resource blueColor]};
    [_segmentControl setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
    [_segmentControl setBackgroundImage:[UIImage createImageWithColor:[Resource blueColor]] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [_segmentControl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    
    [view addSubview:_segmentControl];
}

-(void)segmentClick:(id)sender{
    UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
    if (segmentControl.selectedSegmentIndex != _selectedIndex) {
        UIViewController *newCtl = segmentControl.selectedSegmentIndex ? self.secondVC : self.firstVC;
        [self replaceController:_currentVC newController:newCtl];
        _selectedIndex = (int)segmentControl.selectedSegmentIndex;
        _currentVC = newCtl;
    }
}

//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    kWeakSelf(self)
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            weakself.currentVC = newController;
        }else{
            weakself.currentVC = oldController;
        }
    }];
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
