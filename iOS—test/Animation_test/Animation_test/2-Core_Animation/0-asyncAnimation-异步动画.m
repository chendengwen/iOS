//
//  asyncAnimation-异步动画.m
//  UI_test
//
//  Created by gary on 2021/10/20.
//

#import "0-asyncAnimation-异步动画.h"

@interface asyncAnimation ()
@property(nonatomic,strong) UIView *colorView1;
@end

@implementation asyncAnimation

-(void)viewDidDisappear:(BOOL)animated {
//    [_colorView1.layer removeAllAnimations];
//    [_colorView1 removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat screenHeight = CGRectGetHeight(self.view.bounds);
        
    _colorView1 = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - 100)/2, 100, 100, 100)];
    _colorView1.backgroundColor = [UIColor redColor];
    [self.view addSubview:_colorView1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((screenWidth - 80)/2, 240, 80, 44);
    [button setTitle:@"Start" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)buttonClicked {
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.fromValue = @(1.0);
    animation1.toValue = @(0.2);
    animation1.duration = 3;
    animation1.removedOnCompletion = YES;
    
    [_colorView1.layer addAnimation:animation1 forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *ctl = [[UIViewController alloc] init];
            ctl.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:ctl animated:YES];
        });
        
    }) ;
    
}

@end
