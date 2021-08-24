//
//  HMViewController.m
//  11-转盘
//
//  Created by apple on 14-9-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMViewController.h"

#import "HMWheelView.h"

@interface HMViewController ()

@property (nonatomic, weak) HMWheelView *wheelView;

@end

@implementation HMViewController
- (IBAction)start:(id)sender {
    [_wheelView startRotating];
}
- (IBAction)stop:(id)sender {
    [_wheelView stopRotating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    HMWheelView *wheel = [HMWheelView wheelView];
    
    wheel.center = self.view.center;
    
    [self.view addSubview:wheel];
    
    _wheelView = wheel;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
