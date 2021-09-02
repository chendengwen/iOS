//
//  ViewController.m
//  Test
//
//  Created by gary on 2021/6/7.
//

#import "ViewController.h"
#import "Dog.h"
#import "MyProxy.h"
#import "objc/runtime.h"

@interface ViewController ()

@property(copy) NSString *nameStr;
@property(strong) dispatch_queue_t queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //使用NSProxy的invoke调用转发实现代理机制，并实现HOOK
    Dog *dog = [Dog alloc];
    MyProxy *proxy = [MyProxy proxyWithObj:dog];
    [proxy performSelector:@selector(barking:) withObject:@4];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    Dog *dog = [Dog alloc];
    NSLog(@"%@--------%p---------%p",dog,dog,&dog);
}

@end
