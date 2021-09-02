//
//  ViewController1.m
//  RAC
//


#import "ViewController1.h"
#import "NSObject+Caculator.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int result = [NSObject makeCaculator:^(CaculatorMaker * _Nonnull maker) {
        maker.add(10).add(20).multiply(2);
        maker.multiply(10);
    }];

    NSLog(@"%d",result);
    
}

@end
