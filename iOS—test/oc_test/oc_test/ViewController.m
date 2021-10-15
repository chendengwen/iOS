//
//  ViewController.m
//  oc_test
//
//  Created by gary on 2021/8/14.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <dlfcn.h>
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScriptCore.h>

#ifndef PT_DENY_ATTACH
#define PT_DENY_ATTACH 31
#endif


typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    void *handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
//    ptrace_ptr_t ptrace_ptr = (ptrace_ptr_t)dlsym(handle, "ptrace"); //dlsy获取"ptrace"函数地址
//    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    
//    class_addIvar(self, 'ss', 1, 2, NULL)

}

- (IBAction)onClicked:(id)sender {
    for (int i = 0; i < 3000000; i ++) {
        i --;
    }
}

-(void)runJS_Hello:(NSString *)name{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
    NSData * jsData = [[NSData alloc] initWithContentsOfFile:path];
    NSString * jsCode = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
    NSString * finiString = [NSString stringWithFormat:jsCode,name];
    JSContext * jsContext = [[JSContext alloc] init];
    [jsContext evaluateScript:finiString];
}


@end



@implementation User



@end
