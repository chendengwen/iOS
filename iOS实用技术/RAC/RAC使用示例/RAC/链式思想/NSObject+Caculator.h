//
//  NSObject+Caculator.h
//  RAC
//


#import <Foundation/Foundation.h>
#import "CaculatorMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Caculator)
+(int)makeCaculator:(void (^)(CaculatorMaker * maker))block;
@end

NS_ASSUME_NONNULL_END
