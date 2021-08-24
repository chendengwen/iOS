//
//  ViewController.m
//  007--自定义KVO
//
//  Created by H on 2017/5/8.
//  Copyright © 2017年 TZ. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

#import "NSObject+KVO.h"

@interface ViewController ()
/**   */
@property(nonatomic,strong)Person * p;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _p = [[Person alloc]init];
    
    //添加观察者!! 
    [_p FF_addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
 
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _p.age = 100;
    // Dispose of any resources that can be recreated.
}


@end
