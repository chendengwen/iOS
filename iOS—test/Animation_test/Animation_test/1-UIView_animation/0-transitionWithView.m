//
//  transitionWithView.m
//  UI_test
//
//  Created by gary on 2021/10/20.
//

#import "0-transitionWithView.h"

@interface transitionWithView ()
{
    UIView *_transView;
}
@end

@implementation transitionWithView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
//    CGFloat screenHeight = CGRectGetHeight(self.view.bounds);
    
    ///UIView transitionWithView
    _transView = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - 100)/2, 100, 100, 100)];
    _transView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_transView];
    
    UIButton *transButton = [UIButton buttonWithType:UIButtonTypeCustom];
    transButton.frame = CGRectMake((screenWidth - 100)/2 , 250, 100, 34);
    [transButton setTitle:@"Start" forState:UIControlStateNormal];
    transButton.backgroundColor = [UIColor blueColor];
    [transButton addTarget:self action:@selector(transButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transButton];
    
}

-(void)transButtonClicked {
    UIView *tmpview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    tmpview.backgroundColor = [UIColor yellowColor];
    [UIView transitionWithView:_transView
                      duration:3
                      options:UIViewAnimationOptionTransitionCurlUp
                      animations:^{
                        [self->_transView addSubview:tmpview];
                      } completion:^(BOOL finished) {
                          [tmpview removeFromSuperview];
    }];
}

@end
