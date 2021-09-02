//
//  RACSequence_.m
//  RAC
//


#import "RACSequence_.h"
#import <ReactiveObjC.h>

@interface RACSequence_ ()

@end

@implementation RACSequence_

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr = @[@"1",@"2",@"3"];
    NSDictionary*dict =@ {@"key1":@"vaule1",@"key2":@"vaule2",@"key3":@"vaule3"};
    
    //快速遍历字典
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        //        NSString*key = x[0];
        //        NSString*value = x[1];
        
        RACTupleUnpack(NSString*key,NSString*value) = x;
        NSLog(@"%@--%@",key,value);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error");
    } completed:^{
        NSLog(@"over-dict");
    }];
    
    //快速遍历数组
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error");
    } completed:^{
        NSLog(@"over-arr");
    }];
    
}

@end
