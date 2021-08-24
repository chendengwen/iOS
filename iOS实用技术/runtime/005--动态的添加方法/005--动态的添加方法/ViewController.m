//
//  ViewController.m
//  005--动态的添加方法
//
//  Created by H on 2017/5/8.
//  Copyright © 2017年 TZ. All rights reserved.
//  当我们调用某个方法的时候.才添加这个方法!!

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person * p = [[Person alloc]init];
    //调用eat方法
    [p performSelector:@selector(eat:) withObject:@"板烧鸡腿堡"];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
