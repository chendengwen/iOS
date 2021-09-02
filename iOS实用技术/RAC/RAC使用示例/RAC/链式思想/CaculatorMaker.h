//
//  Caculator.h
//  RAC
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CaculatorMaker : NSObject
/**计算结果*/
@property (nonatomic,assign)int  result;
/**加法*/
-(CaculatorMaker*(^)(int))add;

/**乘法*/
-(CaculatorMaker*(^)(int))multiply;
@end

NS_ASSUME_NONNULL_END
