//
//  Caculator.m
//  RAC
//


#import "CaculatorMaker.h"

@implementation CaculatorMaker
-(CaculatorMaker*(^)(int))add{
    return ^(int num){
        self->_result += num;
        return self;
    };
}

-(CaculatorMaker*(^)(int))multiply{
    return ^(int num){
        self->_result *= num;
        return self;
    };
}
@end
