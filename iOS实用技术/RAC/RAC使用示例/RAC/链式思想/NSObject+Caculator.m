//
//  NSObject+Caculator.m
//  RAC
//


#import "NSObject+Caculator.h"

@implementation NSObject (Caculator)
+ (int)makeCaculator:(void (^)(CaculatorMaker * maker))block{
    // 创建计算制造者
    CaculatorMaker *maker = [[CaculatorMaker alloc] init];
    // 计算
    block(maker);
    return maker.result;
}
@end
