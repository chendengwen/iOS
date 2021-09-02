//
//  Caculator.m
//  RAC
//


#import "Caculator.h"

@implementation Caculator
- (instancetype)add:(int (^)(int result))block
{
    _result = block(_result);
    return self;
}
- (instancetype)equle:(BOOL (^)(int))block
{
    _isEqule = block(_result);
    return self;
}
@end
