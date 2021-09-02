//
//  ViewController2.m
//  RAC
//


#import "ViewController2.h"
#import "Caculator.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    Caculator *caculator = [[Caculator alloc] init];
    BOOL isEqule = [[[caculator add:^(int result){
        result += 10;
        result += 20;
        return  result;
    }] equle:^BOOL(int result) {
        return result == 30;
    }] isEqule];
    NSLog(@"%d",isEqule);
}
@end
