//
//  ViewController.m
//  fishhook_test
//
//  Created by gary on 2021/9/14.
//

#import "ViewController.h"
#import "fishhook.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"hello-1");
    [self hook_NSLog];
    NSLog(@"hello-2");
    
    [self hook_func];
    func("HotPotCat");
}

-(void)hook_NSLog{
    struct rebinding rebindNSLog;
    rebindNSLog.name = "NSLog";
    rebindNSLog.replacement = HP_NSLog;
    rebindNSLog.replaced = (void *)&sys_NSLog;
    
    struct rebinding rebinds[] = {rebindNSLog};
    rebind_symbols(rebinds, 1);
}

//原函数-函数指针
static void (*sys_NSLog)(NSString *format, ...);

//新函数
void HP_NSLog(NSString *format, ...){
    format = [format stringByAppendingFormat:@" + hook"];
    sys_NSLog(format);
}

//----------------------------------------------------------

void func(const char * str) {
    NSLog(@"%s",str);
}

- (void)hook_func {
    struct rebinding rebindFunc;
    rebindFunc.name = "func";
    rebindFunc.replacement = HP_func;
    rebindFunc.replaced = (void *)&original_func;
    
    struct rebinding rebinds[] = {rebindFunc};
    
    rebind_symbols(rebinds, 1);
}
//原函数，函数指针
static void (*original_func)(const char * str);

//新函数
void HP_func(const char * str) {
    NSLog(@"Hook func");
    original_func(str);
}


@end
