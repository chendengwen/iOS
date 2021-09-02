//
//  Caculator.h
//  RAC
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Caculator : NSObject
@property (nonatomic, assign) int result;
@property (nonatomic, assign) BOOL isEqule;
- (instancetype)add:(int(^)(int result))block;
- (instancetype)equle:(BOOL(^)(int result))block;
@end

NS_ASSUME_NONNULL_END
