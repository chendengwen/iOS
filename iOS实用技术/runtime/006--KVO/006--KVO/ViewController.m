//
//  ViewController.m
//  006--KVO
//
//  Created by H on 2017/5/8.
//  Copyright © 2017年 TZ. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
@interface ViewController ()
/**   */
@property(nonatomic,strong)Person * p;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _p = [[Person alloc]init];
    
    [_p addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"%@",change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _p.age = 100;
    
    
    
    
}


@end
