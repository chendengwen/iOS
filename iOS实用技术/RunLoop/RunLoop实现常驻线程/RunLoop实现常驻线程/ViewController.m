//
//  ViewController.m
//  RunLoop实现常驻线程
//
//  Created by 陈登文 on 2021/8/25.
//

#import "ViewController.h"
#import "RunLoopObject.h"

@interface ViewController ()
{
    NSThread *_thread;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSThread *thread = [RunLoopObject threadDispatch];
    NSLog(@"current thread == %p, name == %@", [NSThread currentThread], [NSThread currentThread].name);
    NSLog(@"thread == %p, name == %@", thread, thread.name);
    
//    sleep(2);
//    NSLog(@"thread == %p, name == %@", thread, thread.name);
}

- (IBAction)buttonClicked:(id)sender {
//    NSLog(@"thread == %p, name == %@", _thread, _thread.name);
}



@end
