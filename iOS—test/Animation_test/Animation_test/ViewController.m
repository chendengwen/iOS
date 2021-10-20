//
//  ViewController.m
//  UI_test
//
//  Created by 陈登文 on 2021/10/19.
//

#import "ViewController.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat screenHeight = CGRectGetHeight(self.view.bounds);
    
//    _colorView1 = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - 100)/2, 100, 100, 100)];
//    _colorView1.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_colorView1];
    
    UIView *colorView2 = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - 100)/2, 250, 100, 100)];
    colorView2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:colorView2];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @(1.0);
    animation2.toValue = @(0.5);
    animation2.duration = 2;
    animation2.autoreverses = YES;
    animation2.repeatCount = MAXFLOAT;
    
    [colorView2.layer addAnimation:animation2 forKey:nil];
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth - 100)/2, 400, 100, 30)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
//    textField.backgroundColor = [UIColor blueColor];
    [self.view addSubview:textField];
    
    
}

-(void)buttonClicked {
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    
//    _colorView1 = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - 100)/2, 100, 100, 100)];
//    _colorView1.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_colorView1];
//
//    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    animation1.fromValue = @(1.0);
//    animation1.toValue = @(0.2);
//    animation1.duration = 3;
//
//    [_colorView1.layer addAnimation:animation1 forKey:nil];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIViewController *ctl = [[UIViewController alloc] init];
//            ctl.view.backgroundColor = [UIColor whiteColor];
//            [self.navigationController pushViewController:ctl animated:YES];
//        });
//
//    }) ;
    
}



-(void)blockaTest:(void (^)(void))aTest blockbTest:(void (^)(void))bTest {
    
}



@end
