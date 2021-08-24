//
//  ViewController.m
//  001--消息发送机制
//
//  Created by H on 2017/5/8.
//  Copyright © 2017年 TZ. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [p performSelector:@selector(eat)];
//    Person * p = [Person alloc];
    //[Person class]
    
    
//    p = [p init];
  Person *  p = objc_msgSend(objc_msgSend(objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init"));
    
    
    
    
    
    
    //Xcode5.0开始 手动设置,才能发送消息!
    objc_msgSend(p, sel_registerName("eat:"),@"香蕉");
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
