//
//  HMViewController.m
//  转盘
//
//  Created by yz on 14-9-4.
//  Copyright (c) 2014年 iThinker. All rights reserved.
//

#import "HMViewController.h"

#import "HMWheelView.h"

@interface HMViewController ()

@property (nonatomic, weak) HMWheelView *wheel;

@end

@implementation HMViewController
- (IBAction)stop:(id)sender {
    [_wheel stopRotation];
}
- (IBAction)start:(id)sender {
    [_wheel startRotation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    HMWheelView *wheel = [HMWheelView wheelView];
    wheel.center = self.view.center;
    _wheel = wheel;
    [self.view addSubview:wheel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
