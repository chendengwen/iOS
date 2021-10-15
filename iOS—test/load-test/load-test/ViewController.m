//
//  ViewController.m
//  load-test
//
//  Created by gary on 2021/7/22.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSSetUncaughtExceptionHandler(<#NSUncaughtExceptionHandler * _Nullable#>)
}


@end


@implementation Person
+(void)load
{
    NSLog(@"%s",__FUNCTION__);
}
@end


@implementation Student
//+(void)load
//{
//    NSLog(@"%s",__FUNCTION__);
//}
@end
