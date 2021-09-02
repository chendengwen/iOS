//
//  RequestViewModel.h
//  RAC
//


#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestViewModel : NSObject
@property(nonatomic, strong, readonly)RACCommand *requestCommand;
@end

NS_ASSUME_NONNULL_END
